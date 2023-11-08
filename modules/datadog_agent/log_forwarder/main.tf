# Datadog Forwarder to ship logs from S3 and CloudWatch, as well as observability data from Lambda functions to Datadog.
# https://github.com/DataDog/datadog-serverless-functions/tree/master/aws/logs_monitoring
resource "aws_cloudformation_stack" "datadog_forwarder_cloudformation_stack" {
  name         = "${var.environment}-${var.name}-datadog-forwarder"
  capabilities = ["CAPABILITY_IAM", "CAPABILITY_NAMED_IAM", "CAPABILITY_AUTO_EXPAND"]
  parameters = {
    DdApiKey     = var.datadog_api_key,
    DdSite       = var.dd_site,
    FunctionName = "${var.environment}-${var.name}-datadog-forwarder"
  }
  template_url = "https://datadog-cloudformation-template.s3.amazonaws.com/aws/forwarder/latest.yaml"
}

# Lambda function created by Datadog Forwarder's Cloud Formation stacks.
data "aws_lambda_function" "datadog_forwarder_lambda" {
  function_name = "${var.environment}-${var.name}-datadog-forwarder"

  # Need to declare explicit dependency, because TF does not automatically recognize
  # that this data depends on the cloud formation stack to create lambda functions.
  depends_on = [
    aws_cloudformation_stack.datadog_forwarder_cloudformation_stack
  ]
}

# CloudWatch Logs subscription filter, which filters and delivers the log content to the
# Datadog lambda forwarder.
resource "aws_cloudwatch_log_subscription_filter" "datadog_log_subscription_filter" {
  count           = var.disable_subscription ? 0 : 1
  name            = "${var.environment}-${var.name}-datadog-log-subscription-filter"
  log_group_name  = var.log_group_name
  destination_arn = data.aws_lambda_function.datadog_forwarder_lambda.arn
  filter_pattern  = var.filter_pattern
}
