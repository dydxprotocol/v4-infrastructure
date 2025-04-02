# -----------------------------------------------------------------------------
# Common
# -----------------------------------------------------------------------------
variable "environment" {
  type        = string
  description = "Name of the environment {dev | dev2 | dev3 | dev4 | dev5 | staging | testnet | public-testnet | testnet1 | testnet2 | mainnet}."

  validation {
    condition = contains(
      ["dev", "dev2", "dev3", "dev4", "dev5", "staging", "testnet", "public-testnet", "testnet1", "testnet2", "mainnet"],
      var.environment
    )
    error_message = "Err: invalid environment. Must be one of {dev | dev2 | dev3 | dev4 | dev5 | staging | testnet | public-testnet | testnet1 | testnet2 | mainnet}."
  }
}

variable "name" {
  type        = string
  description = "Name of the app."
}

variable "region" {
  type        = string
  description = "AWS region to deploy the metric ingestor"
}

# -----------------------------------------------------------------------------
# Networking
# -----------------------------------------------------------------------------
variable "cidr_vpc" {
  type        = string
  description = "IPv4 CIDR block for the VPC."
}

# -----------------------------------------------------------------------------
# Datadog
# -----------------------------------------------------------------------------

variable "datadog_api_key" {
  type        = string
  description = "Datadog API key"
  sensitive   = true
}

variable "datadog_site" {
  type        = string
  description = "Datadog API site to send data to"
  default     = null
}

variable "metrics_namespace" {
  type        = string
  description = "metrics namespace"
  default     = "dydxprotocol"
}

variable "validators" {
  type = list(object({
    address              = string
    openmetrics_endpoint = string
    endpoint_type        = string
    machine_id           = optional(string)
  }))
  description = "List of validators for which to collect metrics"
}

variable "metrics" {
  type        = list(string)
  description = <<-EOT
    The list of metrics to track.
    Cosmos Telemetry and go-metrics support some metrics out of the box:
      https://docs.cosmos.network/master/core/telemetry.html
      https://github.com/armon/go-metrics/blob/master/metrics.go#L242
    Custom metrics for dYdX protocol are usually in the form of <module>.*
  EOT
  default = [
    ".*"
  ]
}

variable "max_returned_metrics" {
  type        = number
  description = "the number of metrics we allow `com.datadoghq.ad.instances` to return."
  # Note: As part of CORE-463, we increased from the datadog default of 2000 so that we are not rate limited.
  default = 20000
}

# -----------------------------------------------------------------------------
# EC2
# -----------------------------------------------------------------------------

variable "ec2_instance_type" {
  type        = string
  description = "Instance type for the Metric Ingestor's EC2 instance"
}

variable "root_block_device_size" {
  type        = number
  description = "Size of root block device in gigabytes"
  default     = 100
}

variable "root_block_device_delete_on_termination" {
  type        = bool
  description = "Whether to delete the root block device on termination"
  default     = false
}

# -----------------------------------------------------------------------------
# Chain Interaction
# -----------------------------------------------------------------------------

variable "chain_metadata_node_base_url" {
  type        = string
  description = "Base URL for the REST API of a full node that will be used to check chain metadata"
}
