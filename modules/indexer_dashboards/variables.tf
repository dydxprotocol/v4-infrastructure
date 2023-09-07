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
