# Lambda function for services
resource "aws_lambda_function" "main" {
  lifecycle {
    ignore_changes = [
      image_uri,
    ]
  }

  for_each = local.lambda_services

  image_uri     = "${aws_ecr_repository.lambda_services[each.key].repository_url}:latest"
  package_type  = "Image"
  function_name = "${each.key}_lambda_function"
  role          = aws_iam_role.lambda_services[each.key].arn
  architectures = ["x86_64"]
  timeout       = 120

  environment {
    variables = merge(
      {
        SERVICE_NAME : each.key,
        NODE_ENV : var.node_environment,
        BUGSNAG_KEY : var.bugsnag_key,
        BUGSNAG_RELEASE_STAGE : var.bugsnag_release_stage,
        # Lambda Services do not send continuous logs, so no need to filter by level as volume of
        # logs from the lambda will be low.
        LOG_LEVEL : "debug",
      },
      {
        for environment_variable in local.postgres_environment_variables :
        environment_variable.name => environment_variable.value
      },
      {
        for environment_variable in local.kafka_environment_variables :
        environment_variable.name => environment_variable.value
      },
      {
        for environment_variable in local.redis_environment_variables :
        environment_variable.name => environment_variable.value
      },
      each.value.environment_variables,
      {
        DB_PASSWORD : jsondecode(data.aws_secretsmanager_secret_version.ender_secrets.secret_string)["db_password"],
      }
    )
  }

  vpc_config {
    subnet_ids         = [for subnet in aws_subnet.private_subnets : subnet.id]
    security_group_ids = [aws_security_group.lambda_services[each.key].id]
  }

  tags = {
    Name        = "${var.environment}-${var.indexers[var.region].name}-${each.key}"
    Environment = var.environment
  }
}
