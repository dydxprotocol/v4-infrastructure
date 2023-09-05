# CloudWatch log group for ECS services.
resource "aws_cloudwatch_log_group" "services" {
  for_each = local.services

  name              = "/ecs/${var.environment}-${var.indexers[var.region].name}-${each.key}"
  retention_in_days = 30

  tags = {
    Name        = "/ecs/${var.environment}-${var.indexers[var.region].name}-${each.key}"
    Environment = var.environment
  }
}

# CloudWatch log group for lambda services
resource "aws_cloudwatch_log_group" "lambda_services" {
  for_each = local.lambda_services

  name              = "/aws/lambda/${aws_lambda_function.main[each.key].function_name}"
  retention_in_days = 30

  tags = {
    Name        = "/aws/lambda/${aws_lambda_function.main[each.key].function_name}"
    Environment = var.environment
  }
}
