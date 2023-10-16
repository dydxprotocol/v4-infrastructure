# ECS Cluster for the indexer.
resource "aws_ecs_cluster" "main" {
  name = "${var.environment}-${var.indexers[var.region].name}-cluster"

  tags = {
    Name        = "${var.environment}-${var.indexers[var.region].name}-cluster"
    Environment = var.environment
  }

  # Enable additional metric collection for ECS containers.
  # https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/ContainerInsights.html
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

# ECS Services for the indexer.
resource "aws_ecs_service" "main" {
  lifecycle {
    # We ignore changes to the `task-definition` of the ECS service as the specific deployed Task Definition
    # is part of our service deploy process. Applying Terraform should not trigger a new deploy of services.
    ignore_changes = [
      task_definition
    ]
  }

  for_each = local.services

  name                = "${var.environment}-${var.indexers[var.region].name}-${each.key}"
  cluster             = aws_ecs_cluster.main.id
  task_definition     = aws_ecs_task_definition.main[each.key].arn
  desired_count       = each.value.ecs_desired_count
  launch_type         = "FARGATE"
  scheduling_strategy = "REPLICA"

  # Cap maximum healthy percent at 100 to prevent multiple indexer tasks
  # running in parallel in the same service.
  deployment_maximum_percent = 200
  # Minimum health percent has to be specified when maximum healthy percent is 100.
  deployment_minimum_healthy_percent = 100

  # Enables ECS Exec for remote debugging of task definitions.
  # See https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-exec.html
  enable_execute_command = true

  network_configuration {
    subnets = each.value.should_deploy_in_rds_subnet ? [
      for subnet_name in var.indexers[var.region].rds_availability_regions :
      aws_subnet.private_subnets[subnet_name].id
    ] : [for subnet in aws_subnet.private_subnets : subnet.id]
    security_groups  = [aws_security_group.services[each.key].id]
    assign_public_ip = true
  }

  dynamic "load_balancer" {
    for_each = each.value.is_public_facing ? tomap({ (each.key) = each.value }) : {}

    content {
      target_group_arn = aws_lb_target_group.services[each.key].arn
      container_name   = "${var.environment}-${var.indexers[var.region].name}-${each.key}-service-container"
      container_port   = 8080
    }
  }

  tags = {
    Name        = "${var.environment}-${var.indexers[var.region].name}-${each.key}"
    Environment = var.environment
    V4Service   = "${each.key}"

    # The DesiredCount here is necessary to capture the desired count in the case that the service
    # is temporarily taken down to a 0 task count.
    DesiredCount = "${each.value.ecs_desired_count}"
  }
}

# ECS Task Definition for each indexer service
resource "aws_ecs_task_definition" "main" {
  for_each = local.services

  family                   = "${var.environment}-${var.indexers[var.region].name}-${each.key}-task"
  network_mode             = "awsvpc"
  execution_role_arn       = module.iam_service_ecs_task_roles[each.key].ecs_task_execution_role_arn
  task_role_arn            = module.iam_service_ecs_task_roles[each.key].ecs_task_role_arn
  requires_compatibilities = ["FARGATE"]
  cpu                      = each.value.task_definition_cpu
  memory                   = each.value.task_definition_memory

  container_definitions = jsonencode(
    # TODO(DEC-842): Add datadog agent container definition
    [
      {
        name = "${var.environment}-${var.indexers[var.region].name}-${each.key}-service-container"
        # Note: Task Definitions created through Terraform are never deployed, but we expect this to be a valid URL
        # in the container image's ECR repository (even if the tag does not exist).
        image = "${aws_ecr_repository.main[each.key].repository_url}:created-by-terraform-with-no-image"

        essential = true
        logConfiguration = {
          logDriver = "awslogs"
          options = {
            awslogs-group         = aws_cloudwatch_log_group.services[each.key].name
            awslogs-region        = var.region
            awslogs-stream-prefix = "ecs"
          }
        }
        cpu               = each.value.task_definition_cpu - module.datadog_agent.datadog_cpu
        memoryReservation = each.value.task_definition_memory - module.datadog_agent.datadog_memory
        portMappings = [
          for port in each.value.ports : {
            containerPort : port,
            hostPort : port,
        }],
        environment = flatten(
          [
            {
              name  = "NODE_ENV",
              value = var.node_environment,
            },
            {
              name  = "BUGSNAG_KEY",
              value = var.bugsnag_key
            },
            # See https://docs.datadoghq.com/profiler/enabling/nodejs/ for DD_ specific environment variables.
            # Note that DD_SERVICE and DD_VERSION are read by default from package.json
            {
              name  = "DD_PROFILING_ENABLED",
              value = "true"
            },
            {
              name  = "DD_ENV",
              value = var.environment
            },
            {
              name  = "BUGSNAG_RELEASE_STAGE",
              value = var.bugsnag_release_stage
            },
            {
              name  = "LOG_LEVEL",
              value = var.log_level
            },
            {
              name  = "SEND_BUGSNAG_ERRORS",
              value = tostring(var.send_bugsnag_errors)
            },
            {
              name  = "SECRET_ID",
              value = local.service_secret_ids[each.key],
            },
            each.value.ecs_environment_variables,
            each.value.requires_postgres_connection ? local.postgres_environment_variables : [],
            each.value.requires_kafka_connection ? local.kafka_environment_variables : [],
            each.value.requires_redis_connection ? local.redis_environment_variables : [],
          ]
        ),
      },
      module.datadog_agent.ecs_fargate_container_definition
    ]
  )

  runtime_platform {
    operating_system_family = "LINUX"
  }

  tags = {
    Name        = "${var.environment}-${var.indexers[var.region].name}-${each.key}-task"
    Environment = var.environment
  }
}
