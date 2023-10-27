variable "env_tag" {
  type        = string
  description = "Env tag to add to all monitors"
}

variable "environment" {
  type        = string
  description = "Environment that all metrics for monitors reside in. All Indexer service metrics should use the env tag."
}

variable "slack_channel" {
  type        = string
  description = "Slack channel to publish all alerts to. If \"\", then no slack channel will be used. Should be prepended with @ such as '@dydx-alerts'"
}

variable "pagerduty_tag" {
  type        = string
  description = "PagerDuty tag to add to all monitors. If \"\", then no PagerDuty tag will be used. Should be prepended with @ such as '@pagerduty-indexer'"
}

variable "ecs_cluster_name" {
  type        = string
  description = "ECS cluster name for the full node"
}

variable "msk_cluster_name" {
  type        = string
  description = "MSK cluster name"
}

variable "team" {
  type        = string
  description = "Team tag to add to all monitors"
}

variable "url" {
  type        = string
  description = "Indexer URL to monitor, should not include https:// or www. Should be something like `indexer.dydx.exchange`"
}

variable "enable_precautionary_monitors" {
  type        = bool
  description = "Whether to enable precautionary monitors"
}
