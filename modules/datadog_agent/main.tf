locals {

  common_environment = merge(var.environment_vars, {
    DD_API_KEY                           = var.datadog_api_key
    DD_LOGS_ENABLED                      = "true"
    DD_LOGS_CONFIG_CONTAINER_COLLECT_ALL = "true"
    DD_SITE                              = var.dd_site
    DD_TAGS                              = "env:${var.env} project:v4 service:${var.service_name}"
  })

  common_container_definition = {
    name              = var.name
    image             = "${var.docker_image_name}:${var.docker_image_tag}",
    cpu               = var.container_cpu_units,
    memoryReservation = var.essential,
    essential         = false,

    dockerLabels = var.docker_labels

    portMappings = [
      {
        protocol      = "tcp",
        containerPort = 8126,
        hostPort      = 8126,
      },
      {
        protocol      = "udp",
        containerPort = 8125,
        hostPort      = 8125,
      }
    ]

    healthCheck = {
      retries = 3,
      command = [
        "CMD-SHELL",
        "agent health"
      ],
      timeout     = 5,
      interval    = 30,
      startPeriod = 15
    }
  }
}
