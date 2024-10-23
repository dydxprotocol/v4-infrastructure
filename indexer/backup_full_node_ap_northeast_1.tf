module "backup_full_node_ap_northeast_1" {
  source = "../modules/validator"
  count  = var.create_backup_full_node ? 1 : 0

  environment = var.environment

  name               = var.backup_full_node_name
  region             = var.region
  availability_zones = var.full_node_availability_zones

  cidr_vpc                    = var.backup_full_node_cidr_vpc
  cidr_public_subnets         = var.backup_full_node_cidr_public_subnets
  tcp_port_to_health_protocol = var.full_node_tcp_port_to_health_protocol
  public_ports                = var.full_node_public_ports

  ecs_task_memory = var.full_node_ecs_task_memory

  additional_service_tags = {
    IsIndexerFullNode = true
  }

  container_chain_home                   = var.full_node_container_chain_home
  container_p2p_persistent_peers         = join(",", var.full_node_container_p2p_persistent_peers)
  container_optimistic_execution_enabled = var.full_node_container_optimistic_execution_enabled
  container_kafka_conn_str               = aws_msk_cluster.main.bootstrap_brokers
  container_non_validating_full_node     = true
  full_node_send_off_chain_messages      = false

  datadog_api_key = var.datadog_api_key
  dd_site         = var.dd_site

  ecr_repository_url = local.node_ecr_repository_url

  ec2_instance_type = var.full_node_ec2_instance_type

  tendermint_log_level = var.full_node_tendermint_log_level

  use_cosmovisor = var.full_node_use_cosmovisor

  use_persistent_docker_volume = var.full_node_use_persistent_docker_volume

  root_block_device_size                  = var.full_node_root_block_device_size
  root_block_device_delete_on_termination = true
  ecs_task_cpu_architecture               = var.fullnode_ecs_task_cpu_architecture

  providers = {
    aws = aws.ap_northeast_1
  }
}

moved {
  from = module.backup_full_node_ap_northeast_1
  to   = module.backup_full_node_ap_northeast_1[0]
}
