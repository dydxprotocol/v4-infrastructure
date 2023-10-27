module "indexer_monitors" {
  count = var.enable_monitoring ? 1 : 0

  source                        = "../modules/indexer_monitors"
  env_tag                       = "v4-${var.environment}"
  environment                   = var.environment
  slack_channel                 = var.monitoring_slack_channel
  pagerduty_tag                 = var.monitoring_pagerduty_tag
  ecs_cluster_name              = var.full_node_name
  msk_cluster_name              = aws_msk_cluster.main.cluster_name
  team                          = var.monitoring_team
  url                           = var.indexer_url
  enable_precautionary_monitors = var.enable_precautionary_monitors
}
