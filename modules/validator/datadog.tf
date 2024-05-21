module "datadog_agent" {
  source = "../datadog_agent"

  env             = var.datadog_env != "" ? var.datadog_env : var.environment
  datadog_api_key = var.datadog_api_key
  dd_site         = var.dd_site
  service_name    = "validator"

  # https://docs.datadoghq.com/containers/docker/prometheus/?tabs=standard#configuration
  docker_labels = {
    "com.datadoghq.ad.instances" = jsonencode(
      [
        {
          "openmetrics_endpoint" : "http://%%host%%:${var.prometheus_port}/metrics?format=prometheus",
          "namespace" : var.metrics_namespace,
          "metrics" : var.metrics,
          "exclude_metrics" : var.exclude_metrics,
          "tags" : ["validator_name:dydx", "is_full_node:${var.container_non_validating_full_node}"],
          "max_returned_metrics" : var.max_returned_metrics
        }
      ]
    ),
    "com.datadoghq.ad.check_names" = jsonencode(
      [
        "openmetrics"
      ]
    ),
    "com.datadoghq.ad.init_configs" = jsonencode(
      [
        {}
      ]
    )
  }
}
