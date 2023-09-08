locals {
  ecs_fargate_environment = merge(
    local.common_environment,
    {
      ECS_FARGATE = "true"
    },
  )

  ecs_fargate_container_definition = merge(
    local.common_container_definition,
    {
      environment = [
        for k, v in local.ecs_fargate_environment :
        {
          name  = k,
          value = v
        }
      ]
    }
  )
}
