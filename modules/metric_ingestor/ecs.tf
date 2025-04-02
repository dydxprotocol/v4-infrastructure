# ECS Cluster for the Metric Ingestor.
resource "aws_ecs_cluster" "main" {
  name = "${var.environment}-${var.name}-cluster"

  tags = {
    Name        = "${var.environment}-${var.name}-cluster"
    Environment = var.environment
  }

  # Enable additional metric collection for ECS containers.
  # https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/ContainerInsights.html
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

# ECS Service for the Metric Ingestor.
resource "aws_ecs_service" "main" {
  name                = "${var.environment}-${var.name}-service"
  cluster             = aws_ecs_cluster.main.id
  task_definition     = aws_ecs_task_definition.main.arn
  desired_count       = 1
  launch_type         = "EC2"
  scheduling_strategy = "DAEMON"

  # Enables ECS Exec for remote debugging of task definitions.
  # See https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-exec.html
  enable_execute_command = true

  tags = {
    Name        = "${var.environment}-${var.name}-service"
    Environment = var.environment
  }
}

# ECS Task Definition for the Metric Ingestor.
resource "aws_ecs_task_definition" "main" {
  family             = "${var.environment}-${var.name}-task"
  network_mode       = "host"
  execution_role_arn = module.iam_ecs_task_roles.ecs_task_execution_role_arn
  task_role_arn      = module.iam_ecs_task_roles.ecs_task_role_arn

  # Note: There is a known bug in the AWS provider which always forces replacement of Task Definitions
  # even if no changes have been made. See here: https://github.com/hashicorp/terraform-provider-aws/issues/11526
  container_definitions = jsonencode(
    [
      merge(
        module.datadog_agent.ecs_ec2_container_definition,
        {
          logConfiguration = {
            logDriver = "awslogs",
            options = {
              "awslogs-group"         = "/ecs/${var.name}",
              "awslogs-region"        = var.region,
              "awslogs-stream-prefix" = "datadog-agent",
              "awslogs-create-group"  = "true"
            }
          }
        }
      )
    ]
  )

  # These volumes are required by the datadog agent definition.
  # See: https://www.datadoghq.com/blog/monitoring-ecs-with-datadog/#deploying-the-agent-in-the-ec2-launch-type
  dynamic "volume" {
    for_each = module.datadog_agent.ecs_ec2_container_volumes
    content {
      host_path = volume.value["host_path"]
      name      = volume.value["name"]
    }
  }

  tags = {
    Name        = "${var.environment}-${var.name}-task"
    Environment = var.environment
  }
}
