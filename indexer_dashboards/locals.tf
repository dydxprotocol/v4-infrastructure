locals {
  template_variable_presets = [for name, variables in var.indexer_services_variable_mapping :
    {
      name = name,
      template_variables = [
        {
          name  = "Environment",
          value = variables.environment,
        },
        {
          name  = "Service",
          value = variables.service,
        },
        {
          name  = "cluster_name",
          value = variables.cluster_name,
        },
        {
          name  = "ecs_cluster_name",
          value = variables.ecs_cluster_name,
        },
        {
          name  = "msk_cluster_name",
          value = variables.msk_cluster_name,
        },
      ]
    }
  ]

  indexer_service_variables = [for name, variables in var.indexer_services_variable_mapping : variables]
  template_variables = [
    {
      name             = "Environment",
      prefix           = "env",
      available_values = [],
      default          = "*",
    },
    {
      name             = "Service",
      prefix           = "service",
      available_values = [],
      default          = "indexer",
    },
    {
      name   = "cluster_name",
      prefix = "cluster_name",
      available_values = [
        for variables in local.indexer_service_variables : variables.cluster_name
      ],
      default = local.indexer_service_variables[0].cluster_name,
    },
    {
      name   = "ecs_cluster_name",
      prefix = "ecs_cluster_name",
      available_values = [
        for variables in local.indexer_service_variables : variables.ecs_cluster_name
      ],
      default = local.indexer_service_variables[0].ecs_cluster_name,
    },
    {
      name   = "msk_cluster_name",
      prefix = "cluster_name",
      available_values = [
        for variables in local.indexer_service_variables : variables.msk_cluster_name
      ],
      default = local.indexer_service_variables[0].msk_cluster_name,
    },
  ]
}
