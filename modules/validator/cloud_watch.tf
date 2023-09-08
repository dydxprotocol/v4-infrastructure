# CloudWatch log group for ECS.
resource "aws_cloudwatch_log_group" "main" {
  name              = "/ecs/${var.environment}-${var.name}"
  retention_in_days = 30

  tags = {
    Name        = "${var.environment}-${var.name}-cloud-watch"
    Environment = var.environment
  }
}
