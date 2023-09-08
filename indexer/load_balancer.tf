# Load balancer for all public services
resource "aws_lb" "public" {
  name               = "${var.environment}-${var.indexers[var.region].name}-lb-public"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.load_balancer_public.id]
  subnets            = [for subnet in aws_subnet.public_subnets : subnet.id]
  ip_address_type    = "ipv4"

  access_logs {
    bucket  = aws_s3_bucket.load_balancer.bucket
    prefix  = "public"
    enabled = "true"
  }

  tags = {
    Name        = "${var.environment}-${var.indexers[var.region].name}-lb-public"
    Environment = var.environment
  }

  depends_on = [aws_internet_gateway.main]
}

# Return 404 by default
resource "aws_lb_listener" "public_http" {
  load_balancer_arn = aws_lb.public.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "application/json"
      status_code  = "404"
    }
  }
}

# HTTPS listener - only created if `var.enable_https` is true
# Returns 404 by default
resource "aws_lb_listener" "public_https" {
  count             = var.enable_https ? 1 : 0
  load_balancer_arn = aws_lb.public.arn
  certificate_arn   = aws_acm_certificate.cert[0].arn
  port              = "443"
  protocol          = "HTTPS"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "application/json"
      status_code  = "404"
    }
  }
}

# Load balancer listener rules are processed in order by priority and should be sorted as such
# ----------------------------------------------------------
# Load balancer listener rules
# ----------------------------------------------------------
# Load balancer rule to redirect all `/v4/ws` paths to socks. ws = websockets

# HTTP rules

resource "aws_lb_listener_rule" "public_http_socks" {
  listener_arn = aws_lb_listener.public_http.arn
  priority     = 20

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.services["socks"].arn
  }

  condition {
    path_pattern {
      values = ["/v4/ws"]
    }
  }
}

# Load balancer rule to redirect all `/v4/*` paths to comlink
resource "aws_lb_listener_rule" "public_http_comlink" {
  listener_arn = aws_lb_listener.public_http.arn
  priority     = 30

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.services["comlink"].arn
  }

  condition {
    path_pattern {
      values = ["/v4/*"]
    }
  }
}

# HTTPS rules - only created if `var.enable_https` is true

# Load balancer rule to redirect all `/v4/ws` paths to socks. ws = websockets
resource "aws_lb_listener_rule" "public_https_socks" {
  count        = var.enable_https ? 1 : 0
  listener_arn = aws_lb_listener.public_https[0].arn
  priority     = 20

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.services["socks"].arn
  }

  condition {
    path_pattern {
      values = ["/v4/ws"]
    }
  }
}

# Load balancer rule to redirect all `/v4/*` paths to comlink
resource "aws_lb_listener_rule" "public_https_comlink" {
  count        = var.enable_https ? 1 : 0
  listener_arn = aws_lb_listener.public_https[0].arn
  priority     = 30

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.services["comlink"].arn
  }

  condition {
    path_pattern {
      values = ["/v4/*"]
    }
  }
}

# Load balancer target group for each public facing service
resource "aws_lb_target_group" "services" {
  for_each = { for k, v in local.services : k => v if v.is_public_facing }

  name        = substr("${var.environment}-${var.indexers[var.region].name}-${each.key}-tg", 0, 32)
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.main.id

  health_check {
    port = each.value.health_check_port
    path = "/health"
  }

  tags = {
    Name        = "${var.environment}-${var.indexers[var.region].name}-${each.key}-tg"
    Environment = var.environment
  }
}
