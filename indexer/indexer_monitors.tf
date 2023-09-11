module "indexer_monitors" {
  count = var.enable_monitoring ? 1 : 0

  source           = "../modules/indexer_monitors"
  env_tag          = var.monitoring_env_tag
  environment      = var.environment
  slack_channel    = var.monitoring_slack_channel
  ecs_cluster_name = var.full_node_name
  msk_cluster_name = aws_msk_cluster.main.cluster_name
  team             = var.monitoring_team
}
