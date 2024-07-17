locals {
  ecs_ec2_environment = merge(local.common_environment,
    {
      DD_LOGS_CONFIG_DOCKER_CONTAINER_FORCE_USE_FILE : "true"
  })

  ecs_ec2_container_definition = merge(
    local.common_container_definition,
    {
      mountPoints = [
        {
          containerPath = "/var/run/docker.sock",
          sourceVolume  = "docker_sock",
          readOnly      = true
        },
        {
          containerPath = "/host/sys/fs/cgroup",
          sourceVolume  = "cgroup",
          readOnly      = true
        },
        {
          containerPath = "/host/proc",
          sourceVolume  = "proc",
          readOnly      = true
        },
        {
          containerPath = "/etc/datadog-agent/conf.d",
          sourceVolume  = "custom_metric_config",
          readOnly      = true
        },
        {
          containerPath = "/etc/datadog-agent/checks.d",
          sourceVolume  = "checks_definitions",
          readOnly      = true
        },
      ],
      environment = [
        for k, v in local.ecs_ec2_environment :
        {
          name  = k,
          value = v
        }
      ]
  })

  # This volume is required by the datadog agent definition.
  # See: https://www.datadoghq.com/blog/monitoring-ecs-with-datadog/#deploying-the-agent-in-the-ec2-launch-type
  ecs_ec2_container_volumes = [
    {
      host_path = "/var/run/docker.sock"
      name      = "docker_sock"
    },
    {
      host_path = "/sys/fs/cgroup/"
      name      = "cgroup"
    },
    {
      host_path = "/proc/"
      name      = "proc"
    },
    {
      host_path = "/endpoint-checker/conf.d/"
      name      = "custom_metric_config"
    },
    {
      host_path = "/endpoint-checker/checks.d/"
      name      = "checks_definitions"
    },
  ]
}
