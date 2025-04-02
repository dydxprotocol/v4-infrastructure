module "datadog_agent" {
  source = "../datadog_agent"

  env             = var.environment
  datadog_api_key = var.datadog_api_key
  dd_site         = var.datadog_site
  service_name    = "metric-ingestor"
}
