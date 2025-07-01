# Certificate for HTTPS listener on the load balancer
resource "aws_acm_certificate" "cert" {
  count             = 1
  domain_name       = var.acm_certificate_domain
  validation_method = "DNS"

  tags = {
    Name        = "${var.environment}-${var.indexers[var.region].name}-acm-cert"
    Environment = var.environment
  }

  lifecycle {
    prevent_destroy = true
  }
}
