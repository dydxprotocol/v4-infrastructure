variable "indexer_services_variable_mapping" {
  type = map(
    object({
      # Environment
      environment = string

      # Service name
      service = string

      # Cluster name for the indexer services
      cluster_name = string

      # ECS cluster name for the full node
      ecs_cluster_name = string

      # MSK cluster name
      msk_cluster_name = string
    })
  )

  description = "Map of variable name to preset values of variables used in indexer services."
}

variable "datadog_api_key" {
  type        = string
  description = "Datadog API key"
  sensitive   = true
}

variable "datadog_app_key" {
  type        = string
  description = "Datadog app key"
  sensitive   = true
}

variable "datadog_api_url" {
  type        = string
  description = "The datadog api url"
  default     = "https://api.datadoghq.com/"
}
