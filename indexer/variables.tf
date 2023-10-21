variable "indexers" {
  type = map(
    object({
      # Name of the indexer.
      name = string

      # Zones the indexer runs in.
      # Should contain 3 availability zones
      # https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-regions-availability-zones.html
      # TODO(DEC-740): See if there's a way to utilize 'aws_availability_zones' and
      #                 skip over availiability zones not in the mappings below.
      availability_zones = list(string)

      # AWS VPC CIDR Block
      vpc_cidr_block = string

      # Mapping of aws availability zones for private subnets to cidr block.
      # Should contain a mapping for each availability zone.
      private_subnets_availability_zone_to_cidr_block = map(any)

      # Mapping of aws availability zones for public subnets to cidr block.
      # Should contain a mapping for each availability zone.
      public_subnets_availability_zone_to_cidr_block = map(any)

      # ELB account id of the AWS account for elastic load balancing in this region (fixed by region).
      # https://docs.aws.amazon.com/elasticloadbalancing/latest/classic/enable-access-logs.html
      elb_account_id = number

      # Availability zone name of the region RDS will run in. This is because distance from RDS to
      # some ECS services is important for reducing RTT latency and can greatly impact performance.
      # Multiple RDS regions are required because aws_db_subnet_group requires a minimum of 2
      # subnets.
      rds_availability_regions = list(string)
    })
  )
  description = "Map of region name to indexer info."
}

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

# NOTE: This does not directly correspond with `environment` and should be separately set based on
# the behavior needed for the Indexer services. E.g. it's possible that a staging environment would
# have this set to "production" to have production logic running in the services.
variable "node_environment" {
  type        = string
  description = "Name of the NODE_ENV variable to set for Indexer services {development | staging | production}."

  validation {
    condition = contains(
      ["development", "staging", "production"],
      var.node_environment
    )
    error_message = "Err: invalid environment. Must be one of {development | staging | production}."
  }
}

variable "bugsnag_release_stage" {
  type        = string
  description = "Name of the BUGSNAG_RELEASE_STAGE variable to set for Indexer services {development | staging | testnet}."

  validation {
    condition = contains(
      ["development", "staging", "testnet", "mainnet"],
      var.bugsnag_release_stage
    )
    error_message = "Err: invalid bugsnag release stage. Must be one of {development | staging | testnet}."
  }
}

variable "send_bugsnag_errors" {
  type        = bool
  description = "Boolean to specify if indexer should sent error logs to bugsnag."
  default     = true
}

variable "region" {
  type        = string
  description = "The region the indexer runs in."
}

variable "rds_db_password" {
  type        = string
  description = "Postgres RDS DB password"
  sensitive   = true
}

variable "bugsnag_key" {
  type        = string
  description = "bugsnag key"
}

variable "msk_instance_type" {
  type        = string
  description = "Instance type for MSK brokers"
}

variable "rds_db_instance_class" {
  type        = string
  description = "Instance class for the Postgres RDS DB"
}

variable "rds_db_allocated_storage_gb" {
  type        = number
  description = "Storage allocated to the Postgres RDS DB in GB"
}

variable "elasticache_redis_num_cache_clusters" {
  type        = number
  description = "Number of elasticache cache clusters"
}

variable "elasticache_redis_node_type" {
  type        = string
  description = "Elasticache Redis node type"
}

variable "elasticache_rate_limit_redis_num_cache_clusters" {
  type        = string
  description = "Number of elasticache cache clusters for rate limit redis, if unset uses elasticache_redis_num_cache_clusters"
  default     = ""
}

variable "elasticache_rate_limit_redis_node_type" {
  type        = string
  description = "Elasticache Redis node type for rate limit redis instance, if unset uses elasticache_redis_node_type"
  default     = ""
}

variable "full_node_name" {
  type        = string
  description = "Name of the indexer full-node"
}

variable "snapshot_full_node_name" {
  type        = string
  description = "Name of the indexer full-node that periodically restarts and uploads snapshots to S3"
}

variable "full_node_availability_zones" {
  type        = list(string)
  description = "Availability zones for the full-node to run in"
}

variable "full_node_container_chain_home" {
  type        = string
  description = "Full-node's home directory for the chain. Used to boot up the chain, and configure the `cmd` in ECS"
}

variable "snapshot_full_node_container_chain_home" {
  type        = string
  description = "Snapshot full-node's home directory for the chain. Used to boot up the chain, and configure the `cmd` in ECS"
}

variable "full_node_key" {
  type        = string
  description = "Full node's P2P key, used by other nodes for P2P"
}

variable "full_node_container_p2p_persistent_peers" {
  type        = list(string)
  description = "Persistent peers of the full-node, comma-separated list of <node_key>@<ip address>"
}

variable "full_node_ecr_repository_name" {
  type        = string
  description = "ECR repo for full-node image"
}

variable "snapshot_full_node_ecr_repository_name" {
  type        = string
  description = "ECR repo for full-node image that periodically uploads snapshots to S3"
}

variable "full_node_ecs_task_memory" {
  type        = number
  description = "Amount (in MiB) of memory used by the task to run the full node"
}

variable "full_node_snapshot_upload_period" {
  type        = number
  description = "Period (in seconds) between full node snapshot uploads"
  default     = 3600
}

variable "full_node_snapshot_ebs_volume_size" {
  type        = number
  description = "Size (in GiB) of the EBS volume used for the fast sync full node"
  default     = 3000
}

variable "full_node_ec2_instance_type" {
  type        = string
  description = "EC2 instance type for the full node instance"
}

variable "full_node_tendermint_log_level" {
  type        = string
  description = "Tendermint log-level of the Indexer full-node"
}

variable "s3_snapshot_bucket" {
  type        = string
  description = "S3 bucket to upload full node snapshots to"
}

variable "full_node_cidr_vpc" {
  type        = string
  description = "IPv4 CIDR block for the VPC of the full node"
}

variable "full_node_cidr_public_subnets" {
  type        = list(string)
  description = "IPv4 CIDR block for the public subnet of the full node"
}

variable "full_node_tcp_port_to_health_protocol" {
  type        = map(string)
  description = "Map of TCP port number to its health check protocol for the full node"
}

variable "full_node_public_ports" {
  type        = list(string)
  description = "List of ports to expose to the public for the full node"
}

variable "full_node_use_cosmovisor" {
  type        = bool
  description = "Whether the full-node will be run using `cosmovisor`"
}

variable "full_node_use_persistent_docker_volume" {
  type        = bool
  description = "Whether to use a persistent docker volume for the full-node"
}

variable "datadog_api_key" {
  type        = string
  description = "Datadog API key"
  sensitive   = true
}

variable "enable_https" {
  type        = bool
  description = "Whether to enable HTTPS for connecting to the indexer"
}

variable "acm_certificate_domain" {
  type        = string
  description = "Domain for ACM certificate if HTTPS is enabled"
}

variable "log_level" {
  type        = string
  description = "Level of logs to output for indexer services. {emerg|alert|crit|error|warning|notice|info|debug}."

  validation {
    condition = contains(
      ["emerg", "alert", "crit", "error", "warning", "notice", "info", "debug"],
      var.log_level
    )
    error_message = "Err: invalid log level. Must be one of {emerg | alert | crit | error | warning | notice | info | debug}."
  }
  default = "info"
}

variable "datadog_log_level" {
  type        = string
  description = "Level of logs to send to datadog for indexer services. {emerg|alert|crit|error|warning|notice|info|debug}."

  validation {
    condition = contains(
      ["emerg", "alert", "crit", "error", "warning", "notice", "info", "debug"],
      var.datadog_log_level
    )
    error_message = "Err: invalid log level. Must be one of {emerg | alert | crit | error | warning | notice | info | debug}."
  }
  default = "error"
}

variable "prevent_breaking_changes_without_force" {
  type        = string
  description = "Prevents bazooka from deploying breaking changes without the force flag"

  validation {
    condition = contains(
      ["true", "false"],
      var.prevent_breaking_changes_without_force
    )
    error_message = "Err: invalid \"prevent breaking changes without force\". Must be one of {true | false}."
  }
  default = "true"
}

variable "dd_site" {
  type        = string
  default     = "datadoghq.com"
  description = "The site that the datadog agent will send data to"
}

variable "enable_monitoring" {
  type        = bool
  description = "Whether to enable datadog monitoring"
  default     = true
}

variable "monitoring_slack_channel" {
  type        = string
  description = "Slack channel to publish all alerts to. If \"\", then no slack channel will be used. Should be prepended with @ such as '@dydx-alerts'"
  default     = ""
}

variable "monitoring_pagerduty_tag" {
  type        = string
  description = "PagerDuty tag to add to all monitors. If \"\", then no PagerDuty tag will be used. Should be prepended with @ such as '@pagerduty-indexer'"
  default     = ""
}

variable "monitoring_team" {
  type        = string
  description = "Team tag to add to all monitors"
  default     = "v4-indexer"
}

variable "monitoring_aws_account_id" {
  type        = string
  description = "Account ID for the AWS account"
  default     = ""
}

variable "enable_precautionary_monitors" {
  type        = bool
  description = "Whether to enable precautionary monitors"
  default     = true
}

variable "indexer_url" {
  type        = string
  description = "indexer URL to monitor, should not include https:// or www. Should be something like `indexer.dydx.exchange`"
  default     = ""
}

variable "datadog_app_key" {
  type        = string
  description = "Datadog app key for monitoring"
  sensitive   = true
  default     = ""
}

variable "datadog_api_url" {
  type        = string
  description = "The datadog api url"
  default     = "https://api.datadoghq.com/"
}

variable "indexer_level_geoblocking" {
  type        = bool
  description = "Whether indexer level geoblocking is enabled, disable if geoblocking is done at DNS/CDN level"
  default     = "true"
}

variable "geoblocked_countries" {
  type        = string
  description = "Comma-delimited string of geoblocked countries"
  default     = "US,MM,CU,IR,KP,SY,CA"
}

variable "indexer_compliance_client" {
  type        = string
  description = "Client to use for compliance data, should be one of {BLOCKLIST | PLACEHOLDER | ELLIPTIC} defaults to ELLIPTIC. PLACEHOLDER / BLOCKLIST should only be used for test-nets / development, and implements hard-coded logic to determine compliance data for addresses. See https://github.com/dydxprotocol/v4-chain/tree/main/indexer/packages/compliance/src/clients for details."

  validation {
    condition = contains(
      ["BLOCKLIST", "PLACEHOLDER", "ELLIPTIC"],
      var.indexer_compliance_client
    )
    error_message = "Err: invalid indexer_compliance_client. Must be one of {BLOCKLIST | PLACEHOLDER | ELLIPTIC}."
  }
  default = "ELLIPTIC"
}

variable "indexer_compliance_blocklist" {
  type        = string
  description = "Comma-delimited addresses to block for the block list compliance client"
  default     = ""
}

variable "ender_ecs_environment_variables" {
  type = list(object({
    name  = string
    value = string
  }))
  description = "Environment variables to set for the Indexer Ender ECS task, in addition to the default values."
  default     = []
}

variable "comlink_ecs_environment_variables" {
  type = list(object({
    name  = string
    value = string
  }))
  description = "Environment variables to set for the Indexer Comlink ECS task, in addition to the default values."
  default     = []
}

variable "socks_ecs_environment_variables" {
  type = list(object({
    name  = string
    value = string
  }))
  description = "Environment variables to set for the Indexer Socks ECS task, in addition to the default values."
  default     = []
}

variable "roundtable_ecs_environment_variables" {
  type = list(object({
    name  = string
    value = string
  }))
  description = "Environment variables to set for the Indexer Roundtable ECS task, in addition to the default values."
  default     = []
}

variable "vulcan_ecs_environment_variables" {
  type = list(object({
    name  = string
    value = string
  }))
  description = "Environment variables to set for the Indexer Vulcan ECS task, in addition to the default values."
  default     = []
}

variable "public_access" {
  type        = bool
  description = "Enables public access of the indexer endpoints."
  default     = true
}
