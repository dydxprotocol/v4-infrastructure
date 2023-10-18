locals {
  port_mappings = [
    for port in keys(var.tcp_port_to_health_protocol) : {
      protocol      = "tcp"
      containerPort = tonumber(port)
      hostPort      = tonumber(port)
    }
  ]

  // Used to toggle whether a docker volume is created for the v4 node.
  use_docker_volumes = var.use_persistent_docker_volume == "" ? [] : ["use_docker_volume"]
  docker_volume_name = var.docker_volume_name == "" ? var.name : var.docker_volume_name
}

# ECS Cluster for the validator.
resource "aws_ecs_cluster" "main" {
  name = "${var.environment}-${var.name}-cluster"

  tags = {
    Name        = "${var.environment}-${var.name}-cluster"
    Environment = var.environment
  }

  # Enable additional metric collection for ECS containers.
  # https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/ContainerInsights.html
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

# ECS Service for the validator.
resource "aws_ecs_service" "main" {
  lifecycle {
    # We ignore changes to the `task-definition` of the ECS service as the specific deployed Task Definition
    # is part of our service deploy process. Applying Terraform should not trigger a new deploy of services.
    ignore_changes = [
      task_definition
    ]
  }

  name                = "${var.environment}-${var.name}-service"
  cluster             = aws_ecs_cluster.main.id
  task_definition     = aws_ecs_task_definition.main.arn
  desired_count       = 1
  launch_type         = "EC2"
  scheduling_strategy = "DAEMON"

  # Cap maximum healthy percent at 100 to prevent multiple validator tasks
  # running in parallel in the same service.
  deployment_maximum_percent = 100
  # Minimum health percent has to be specified when maximum healthy percent is 100.
  deployment_minimum_healthy_percent = 0

  # Enables ECS Exec for remote debugging of task definitions.
  # See https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-exec.html
  enable_execute_command = true

  tags = merge(tomap({
    Name        = "${var.environment}-${var.name}-service"
    Environment = var.environment
    V4Service   = "v4-node"
  }), var.additional_service_tags)
}

# ECS Task Definition for the Validator.
resource "aws_ecs_task_definition" "main" {
  family             = "${var.environment}-${var.name}-task"
  network_mode       = "host"
  execution_role_arn = module.iam_ecs_task_roles.ecs_task_execution_role_arn
  task_role_arn      = module.iam_ecs_task_roles.ecs_task_role_arn

  # Note: There is a known bug in the AWS provider which always forces replacement of Task Definitions
  # even if no changes have been made. See here: https://github.com/hashicorp/terraform-provider-aws/issues/11526
  container_definitions = jsonencode(
    flatten(
      [
        {
          # Note the suffix "service-container" here is relevant as it's how we denote the main container
          name = "${var.environment}-${var.name}-service-container"
          # Note: Task Definitions created through Terraform are never deployed, but we expect this to be a valid URL
          # in the container image's ECR repository (even if the tag does not exist).
          image = "${var.ecr_repository_url}:created-by-terraform-with-no-image"

          environment = flatten(
            [
              var.use_cosmovisor ? [
                {
                  # Cosmovisor uses the same home directory as `dydxprotocold` to store binaries
                  # and upgrade info.
                  name  = "DAEMON_HOME",
                  value = var.container_chain_home,
                },
                {
                  # Name of the binary cosmovisor should run.
                  name  = "DAEMON_NAME",
                  value = "dydxprotocold"
                }
              ] : [],
              {
                name  = "DD_ENV",
                value = var.datadog_env != "" ? var.datadog_env : var.environment,
              },
            ]
          )

          entryPoint = var.entry_point != null ? var.entry_point : [
            # Execute a shell with a single command line string to enable shell expansion (sh -c "command line string").
            "sh",
            "-c",
            # Build the single command line string which supports shell expansion via "$(command)".
            join(" ", flatten([
              var.use_cosmovisor ? ["/dydxprotocol/start.sh", "run"] : ["dydxprotocold"],
              "start",
              # Commenting out due to --trace overriding the log_level in Cosmos 0.47.3.
              # See https://github.com/cosmos/cosmos-sdk/blob/v0.47.3/server/util.go#L178-L179
              # TODO(DEC-2042): Re-enable trace flag.
              #"--trace",              # print out full stack trace on errors.
              "--log_format", "json", # (json|plain): plain has ANSI color, which makes logging harder to read.
              "--log_level", var.tendermint_log_level,
              "--home", var.container_chain_home,
              "--non-validating-full-node=${tostring(var.container_non_validating_full_node)}",
              # For now, run MEV telemetry only on full nodes
              "--mev-telemetry-enabled=${tostring(var.container_non_validating_full_node)}",
              var.container_kafka_conn_str != "" ? [
                "--indexer-kafka-conn-str", var.container_kafka_conn_str,
              ] : [],
              "--p2p.persistent_peers", var.container_p2p_persistent_peers,
              "--p2p.seed_mode=${tostring(var.container_seed_mode)}",
              # Reference https://github.com/tendermint/tendermint/issues/9480 for why it's a dash and not
              # an underscore.
              length(aws_eip.validator_eip) > 0 ? "--p2p.external-address ${aws_eip.validator_eip[0].public_ip}:26656" : "",
              # Get the local IP address of the ECS host from the Instance Metadata Service (IMDS) which is
              # necessary for this container to be able to communicate with the datadog agent.
              # See https://docs.datadoghq.com/containers/amazon_ecs/apm/?tab=ec2metadataendpoint#configure-the-trace-agent-endpoint
              # for additional details.
              "--dd-agent-host $(wget -O - http://169.254.169.254/latest/meta-data/local-ipv4)",
              "--bridge-daemon-eth-rpc-endpoint", var.bridge_daemon_eth_rpc_endpoint,
            ]))
          ]
          essential    = true
          portMappings = local.port_mappings

          memoryReservation = var.ecs_task_memory

          # Increases open file limit (default is 1024).
          # See Tendermint documentation: https://docs.tendermint.com/v0.34/tendermint-core/running-in-production.html#p2p
          # See AWS documentation: https://docs.aws.amazon.com/AmazonECS/latest/APIReference/API_Ulimit.html
          ulimits = [
            {
              name : "nofile",
              softLimit : 8192,
              hardLimit : 8192
            }
          ]

          logConfiguration = {
            logDriver = "json-file"
            options = {
              "max-size" : "1g",
              "max-file" : "3"
            }
          }

          mountPoints = flatten(
            [
              var.use_persistent_docker_volume ? [
                {
                  sourceVolume  = local.docker_volume_name,
                  containerPath = var.container_chain_home,
                }
              ] : []
            ]
          )
        },
        module.datadog_agent.ecs_ec2_container_definition,
        # Separate container to use to run commands with the `dydxprotocold` binary or manually change the files in
        # the home directory of the validator.
        var.use_persistent_docker_volume ? [
          {
            name              = "docker-volume-container",
            image             = "bash:latest"
            essential         = false
            memoryReservation = 128

            command = [
              "tail",
              "-f",
              "/dev/null"
            ]

            mountPoints = [
              {
                sourceVolume  = local.docker_volume_name,
                containerPath = "/dydxprotocol"
              }
            ]
          }
        ] : []
      ]
    )
  )

  # These volumes are required by the datadog agent definition.
  # See: https://www.datadoghq.com/blog/monitoring-ecs-with-datadog/#deploying-the-agent-in-the-ec2-launch-type
  dynamic "volume" {
    for_each = module.datadog_agent.ecs_ec2_container_volumes
    content {
      host_path = volume.value["host_path"]
      name      = volume.value["name"]
    }
  }

  dynamic "volume" {
    for_each = local.use_docker_volumes
    content {
      name = local.docker_volume_name
      docker_volume_configuration {
        // "shared" indicates the docker volume should be persistent.
        scope = "shared"
        // "autoprovision" indicates the volume should be created if it doesn't already exist.
        autoprovision = true
        // "local" indicates the driver for the volume should be the default Docker volume driver.
        driver = "local"
      }
    }
  }

  tags = {
    Name        = "${var.environment}-${var.name}-task"
    Environment = var.environment
  }
}
