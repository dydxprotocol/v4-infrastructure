module "full_node_snapshot_ap_northeast_1" {
  source = "../modules/validator"

  environment = var.environment

  name               = var.snapshot_full_node_name
  region             = var.region
  availability_zones = var.full_node_availability_zones

  cidr_vpc                    = var.full_node_cidr_vpc
  cidr_public_subnets         = var.full_node_cidr_public_subnets
  tcp_port_to_health_protocol = var.full_node_tcp_port_to_health_protocol
  public_ports                = var.full_node_public_ports

  ecs_task_memory = var.full_node_ecs_task_memory

  additional_service_tags = {
    IsIndexerFullNode = true
  }

  container_chain_home               = var.snapshot_full_node_container_chain_home
  container_p2p_persistent_peers     = join(",", var.full_node_container_p2p_persistent_peers)
  container_non_validating_full_node = true

  datadog_api_key = var.datadog_api_key
  dd_site         = var.dd_site

  # in public testnet, use the node image which contains the snapshot script.
  # in dev environments, we build separate images.
  # TODO(CLOB-976): Determine if mainnet configuration uses a separate image.
  ecr_repository_url = contains(["testnet", "testnet1", "testnet2"], var.environment) ? local.node_ecr_repository_url : local.snapshot_node_ecr_repository_url

  ec2_instance_type = var.full_node_ec2_instance_type

  tendermint_log_level = var.full_node_tendermint_log_level

  use_cosmovisor = var.full_node_use_cosmovisor

  create_validator_eip = false

  use_persistent_docker_volume = var.full_node_use_persistent_docker_volume

  datadog_env = "snapshot-${var.environment}"

  root_block_device_size = var.full_node_snapshot_ebs_volume_size

  entry_point = [
    "sh",
    "-c",
    join(" ", [
      "/dydxprotocol/snapshot.sh",
      "--s3_snapshot_bucket",
      var.s3_snapshot_bucket,
      "--genesis_file_rpc_address",
      format("http://%s:26657", split(":",
        split("@", var.full_node_container_p2p_persistent_peers[0])[1]
      )[0]),
      "--p2p_seeds",
      join(",", var.full_node_container_p2p_persistent_peers),
      "--upload_period",
      var.full_node_snapshot_upload_period,
      # Get the local IP address of the ECS host from the Instance Metadata Service (IMDS) which is
      # necessary for this container to be able to communicate with the datadog agent.
      # See https://docs.datadoghq.com/containers/amazon_ecs/apm/?tab=ec2metadataendpoint#configure-the-trace-agent-endpoint
      # for additional details.
      "--dd_agent_host $(wget -O - http://169.254.169.254/latest/meta-data/local-ipv4)",
    ])
  ]

  additional_task_role_policies = [
    {
      name  = "S3 snapshot bucket access",
      value = aws_iam_policy.ecs_task_s3_policy.arn,
    },
  ]

  providers = {
    aws = aws.ap_northeast_1
  }
}
