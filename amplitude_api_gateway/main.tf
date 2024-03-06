resource "aws_apigatewayv2_api" "this" {
  name                         = "dydx-amplitude-proxy"
  api_key_selection_expression = "$request.header.x-api-key"
  protocol_type                = "HTTP"
  route_selection_expression   = "$request.method $request.path"

  cors_configuration {
    allow_credentials = false
    allow_headers = [
      "*"
    ]
    allow_methods = [
      "*"
    ]
    allow_origins = [
      "*"
    ]
    expose_headers = [
      "*"
    ]
    max_age = 0
  }

  tags = {}
}

resource "aws_apigatewayv2_stage" "this" {
  name   = "proxy-main"
  api_id = aws_apigatewayv2_api.this.id
  tags   = {}

  default_route_settings {
    detailed_metrics_enabled = false
    throttling_burst_limit   = 5000
    throttling_rate_limit    = 10000
  }

  deployment_id = aws_apigatewayv2_deployment.this.id
}

resource "aws_apigatewayv2_route" "this" {
  api_id             = aws_apigatewayv2_api.this.id
  api_key_required   = false
  authorization_type = "NONE"
  route_key          = "ANY /2/httpapi"

  target = "integrations/${aws_apigatewayv2_integration.this.id}"
}

resource "aws_apigatewayv2_integration" "this" {
  api_id                 = aws_apigatewayv2_api.this.id
  connection_type        = "INTERNET"
  integration_method     = "ANY"
  integration_type       = "HTTP_PROXY"
  integration_uri        = "https://api2.amplitude.com/2/httpapi"
  timeout_milliseconds   = 30000
  payload_format_version = "1.0"
}

resource "aws_apigatewayv2_deployment" "this" {
  depends_on = [aws_apigatewayv2_route.this]
  api_id     = aws_apigatewayv2_api.this.id
}
