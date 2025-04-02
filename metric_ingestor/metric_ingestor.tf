module "metric_ingestor" {
  count = var.enabled ? 1 : 0

  source = "../modules/metric_ingestor"

  environment = var.environment
  name        = "metric-ingestor"
  region      = var.region

  datadog_api_key = var.datadog_api_key
  datadog_site    = var.datadog_site

  validators = var.validators

  chain_metadata_node_base_url = var.chain_metadata_node_base_url

  ec2_instance_type = var.ec2_instance_type
  cidr_vpc          = var.cidr_vpc
}
