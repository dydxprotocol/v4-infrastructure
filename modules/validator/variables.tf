# -----------------------------------------------------------------------------
# Common
# -----------------------------------------------------------------------------
variable "environment" {
  type        = string
  description = "Name of the environment {dev | dev2 | dev3 | dev4 | dev5 | staging | testnet | public-testnet | research | testnet1 | testnet2 | mainnet}."

  validation {
    condition = contains(
      ["dev", "dev2", "dev3", "dev4", "dev5", "staging", "testnet", "public-testnet", "research", "testnet1", "testnet2", "mainnet"],
      var.environment
    )
    error_message = "Err: invalid environment. Must be one of {dev | dev2 | dev3 | dev4 | dev5 | staging | testnet | public-testnet | research | testnet1 | testnet2 | mainnet}."
  }
}

variable "name" {
  type        = string
  description = "Name of the app."
}

variable "region" {
  type        = string
  description = "Region to use."
}

variable "additional_service_tags" {
  type        = map(string)
  description = "Additional tags to add to the validator service."
  default     = {}
}

variable "availability_zones" {
  type        = list(string)
  description = "Zones to use. Must be valid zones under specified region."

  validation {
    condition     = length(var.availability_zones) == 2
    error_message = "Err: Exactly two availability zones are required"
  }
}

# -----------------------------------------------------------------------------
# Networking
# -----------------------------------------------------------------------------
variable "cidr_vpc" {
  type        = string
  description = "IPv4 CIDR block for the VPC."
}

variable "cidr_public_subnets" {
  type        = list(string)
  description = "IPv4 CIDR blocks public subnets."

  validation {
    condition     = length(var.cidr_public_subnets) == 2
    error_message = "Err: Exactly two public subnets are required"
  }
}

variable "tcp_port_to_health_protocol" {
  type        = map(string)
  description = "Map of TCP port number to its health check protocol."
}

variable "public_ports" {
  type        = list(string)
  description = "List of ports that should be exposed to the public internet."
}

# -----------------------------------------------------------------------------
# ECS
# -----------------------------------------------------------------------------
variable "ecs_task_memory" {
  type        = number
  description = "Amount (in MiB) of memory used by the task (soft limit)."
}

variable "tendermint_log_level" {
  type        = string
  description = "Log level for Tendermint (trace|debug|info|warn|error|fatal|panic)"
}

variable "container_chain_home" {
  type        = string
  description = "Chain's directory for config and data."
}

variable "entry_point" {
  description = "Entry point for the ECS task container."
  type        = list(string)
  default     = null
}

variable "container_price_feed_enabled" {
  type        = bool
  description = "Whether the price feed daemon is enabled for this node. For validator nodes, this value should be `true`. For full nodes, this value should be `false`"
  default     = true
}

variable "container_non_validating_full_node" {
  type        = bool
  description = "Whether non-validating full-node mode is enabled for this node. For validator nodes, this value should be `false`. For full nodes, this value should be `true`"
  default     = false
}

variable "container_p2p_persistent_peers" {
  type        = string
  description = "List of persistent peers that validator node should connect to; comma-separated."
}

variable "container_kafka_conn_str" {
  type        = string
  description = "Kafka connection string used by the node to send messages to the Indexer. This value should only be set for nodes connected to an Indexer."
  default     = ""
}

variable "container_seed_mode" {
  type        = bool
  description = "Whether the node is a seed node"
  default     = false
}

variable "use_cosmovisor" {
  type    = bool
  default = true
}

variable "bridge_daemon_eth_rpc_endpoint" {
  type        = string
  description = "Ethereum RPC endpoint for the bridge daemon."
  sensitive   = true
  default     = "https://eth-sepolia.g.alchemy.com/v2/demo"
}

# -----------------------------------------------------------------------------
# Datadog
# -----------------------------------------------------------------------------

variable "datadog_api_key" {
  type        = string
  description = "Datadog API key"
  sensitive   = true
}

variable "datadog_env" {
  type        = string
  description = "Datadog Environment"
  default     = ""
}

variable "prometheus_port" {
  type        = number
  description = "the prometheus port used in the `com.datadoghq.ad.instances`."
  default     = 1317
}

variable "metrics_namespace" {
  type        = string
  description = "metrics namespace"
  default     = "dydxprotocol"
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
# ECR / image
# -----------------------------------------------------------------------------
variable "ecr_repository_url" {
  type        = string
  description = "ECR repository URL."
}

# -----------------------------------------------------------------------------
# EC2
# -----------------------------------------------------------------------------

variable "ec2_instance_type" {
  type        = string
  description = "Instance type for the validator EC2 instance"
}

variable "root_block_device_size" {
  type        = number
  description = "Size of root block device in gigabytes"
  default     = 3000
}

variable "root_block_device_delete_on_termination" {
  type        = bool
  description = "Whether to delete the root block device on termination"
  default     = false
}

variable "use_persistent_docker_volume" {
  type        = bool
  description = "Whether to use a persistent docker volume for the v4-node home directory. If true, the v4-node will not have it's state cleared after a restart of the task."
  default     = false
}

variable "create_validator_eip" {
  type        = bool
  description = "Whether to create an elastic IP for the validator."
  default     = true
}

variable "docker_volume_name" {
  type        = string
  description = "Name of docker volume to use for the v4-node. If not passed in, name of validator is used."
  default     = ""
}

variable "additional_task_role_policies" {
  type = list(object({
    name  = string
    value = string
  }))
  description = "List of additional policy ARNs to attach to the ECS task role."
  default     = []
}

variable "dd_site" {
  type        = string
  default     = "datadoghq.com"
  description = "The site that the datadog agent will send data to"
}
