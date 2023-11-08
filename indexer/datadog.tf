module "datadog_agent" {
  source = "../modules/datadog_agent"

  env             = var.environment
  datadog_api_key = var.datadog_api_key
  dd_site         = var.dd_site
  service_name    = "indexer"
  docker_labels = {
    "com.datadoghq.ad.instances"    = jsonencode([{}]),
    "com.datadoghq.ad.check_names"  = jsonencode([{}]),
    "com.datadoghq.ad.init_configs" = jsonencode([{}])
  }
}

module "datadog_log_forwarder_indexer_services" {
  source   = "../modules/datadog_agent/log_forwarder"
  for_each = local.services

  environment          = var.environment
  name                 = "${var.environment}-${var.indexers[var.region].name}-${each.key}"
  datadog_api_key      = var.datadog_api_key
  log_group_name       = aws_cloudwatch_log_group.services[each.key].name
  filter_pattern       = local.log_level_filter_pattern[var.datadog_log_level]
  dd_site              = var.dd_site
  disable_subscription = contains(var.services_disable_dd_log, each.key)
}

module "datadog_log_fowarder_indexer_lambda_services" {
  source   = "../modules/datadog_agent/log_forwarder"
  for_each = local.lambda_services

  environment     = var.environment
  name            = "${var.environment}-${var.indexers[var.region].name}-${each.key}"
  datadog_api_key = var.datadog_api_key
  log_group_name  = aws_cloudwatch_log_group.lambda_services[each.key].name
  # Lambdas do not send continuous logs, so no need to filter by level as volume of logs from
  # the lambdas will be low.
  filter_pattern = ""
  dd_site        = var.dd_site
}

# Create filter pattern for all log levels <= chosen level
# E.g. for "info" we want "error", "crit", "alert", and "emerg", but not "warning", "info", or 
# "debug"
# See https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/FilterAndPatternSyntax.html
# for details on Cloudwatch filter pattern syntax
locals {
  log_level_filter_pattern = {
    for index, log_level in local.log_levels :
    log_level => join(
      " ",
      [
        for inner_index, inner_log_level in local.log_levels :
        "?\"\\\"level\\\":\\\"${inner_log_level}\\\"\"" if inner_index <= index
      ],
    )
  }
}
