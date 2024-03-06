# ----------------------------------------------------------
# RDS Security Group and Rules
# ----------------------------------------------------------
resource "aws_security_group" "rds" {
  name   = "${var.environment}-${var.indexers[var.region].name}-rds-sg"
  vpc_id = aws_vpc.main.id

  # Allow all traffic from the indexer's VPC cidr block, devboxes, lambdas services and ECS
  # services that require RDS for default postgres port.
  ingress {
    from_port   = local.rds_port
    to_port     = local.rds_port
    protocol    = "tcp"
    cidr_blocks = ["${var.indexers[var.region].vpc_cidr_block}"]
    security_groups = flatten([
      aws_security_group.devbox.id,
      # Lambda Services
      [
        for service in keys(local.lambda_services) :
        local.lambda_services[service].requires_postgres_connection ?
        [aws_security_group.lambda_services[service].id] :
        []
      ],
      # ECS Services
      [
        for service in keys(local.services) :
        local.services[service].requires_postgres_connection ?
        [aws_security_group.services[service].id] :
        []
      ],
    ])
  }

  # Allow all outbound traffic from default postgres port.
  egress {
    from_port   = local.rds_port
    to_port     = local.rds_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.environment}-${var.indexers[var.region].name}-rds-sg"
    Environment = "${var.environment}"
  }
}

# ----------------------------------------------------------
# MSK Security Group and Rules
# ----------------------------------------------------------
resource "aws_security_group" "msk" {
  name   = "${var.environment}-${var.indexers[var.region].name}-msk-sg"
  vpc_id = aws_vpc.main.id

  # Allow all traffic from the indexer's VPC cidr block, devboxes, lambda services, the V4 full
  # node and ECS services that require MSK for port 9092 (default kafka port)
  ingress {
    from_port   = 9092
    to_port     = 9092
    protocol    = "tcp"
    cidr_blocks = ["${var.indexers[var.region].vpc_cidr_block}"]
    security_groups = flatten([
      aws_security_group.devbox.id,
      module.full_node_ap_northeast_1.aws_security_group_id,
      # Lambda Services
      [
        for service in keys(local.lambda_services) :
        local.lambda_services[service].requires_kafka_connection ?
        [aws_security_group.lambda_services[service].id] :
        []
      ],
      # ECS Services
      [
        for service in keys(local.services) :
        local.services[service].requires_kafka_connection ?
        [aws_security_group.services[service].id] :
        []
      ],
    ])
  }

  # Allow all outbound traffic from port 9092 (default kafka port).
  egress {
    from_port   = 9092
    to_port     = 9092
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.environment}-${var.indexers[var.region].name}-msk-sg"
    Environment = "${var.environment}"
  }
}

# ----------------------------------------------------------
# Redis Security Group and Rules
# ----------------------------------------------------------
resource "aws_security_group" "redis" {
  name   = "${var.environment}-${var.indexers[var.region].name}-redis-sg"
  vpc_id = aws_vpc.main.id

  # Allow all traffic from devboxes, lambda services and ECS services that require redis
  # for port 6379 (default redis port)
  ingress {
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = ["${var.indexers[var.region].vpc_cidr_block}"]
    security_groups = flatten([
      aws_security_group.devbox.id,
      # Lambda Services
      [
        for service in keys(local.lambda_services) :
        local.lambda_services[service].requires_redis_connection ?
        [aws_security_group.lambda_services[service].id] :
        []
      ],
      # ECS Services
      [
        for service in keys(local.services) :
        local.services[service].requires_redis_connection ?
        [aws_security_group.services[service].id] :
        []
      ],
    ])
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.environment}-${var.indexers[var.region].name}-redis-sg"
    Environment = "${var.environment}"
  }
}

# ----------------------------------------------------------
# Devbox Security Group and Rules
# ----------------------------------------------------------
# Devbox security group will be used for EC2 instances that can be ssh'd into and can connect with
# all the other indexer components that are kept in the private subnets, similar to v3 devboxes.
resource "aws_security_group" "devbox" {
  name   = "${var.environment}-${var.indexers[var.region].name}-devbox-sg"
  vpc_id = aws_vpc.main.id

  # Allow ssh in from everywhere.
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic.
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.environment}-${var.indexers[var.region].name}-devbox-sg"
    Environment = "${var.environment}"
  }
}

# ----------------------------------------------------------
# ECS Services
# ----------------------------------------------------------
resource "aws_security_group" "services" {
  for_each = local.services

  name   = "${var.environment}-${var.indexers[var.region].name}-${each.key}-sg"
  vpc_id = aws_vpc.main.id

  # Allow all outbound traffic.
  # TODO(DEC-900): Investigate restricting security group permissions
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name        = "${var.environment}-${var.indexers[var.region].name}-${each.key}-sg"
    Environment = var.environment
  }
}

# AWS security group rule to allow devboxes to access ports for all services
resource "aws_security_group_rule" "devbox_to_services" {
  for_each = { for service_port in
    distinct(flatten([
      for service_id, service in local.services : [
        for port in service.ports : {
          key  = service_id
          port = port
        }
      ]
    ])) : "${service_port.key}_${service_port.port}" => service_port
  }
  security_group_id        = aws_security_group.services[each.value.key].id
  type                     = "ingress"
  from_port                = each.value.port
  to_port                  = each.value.port
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.devbox.id
  description              = aws_security_group.devbox.name
}

# AWS security group rule to allow the loadbalance to access ports for all public facing services
resource "aws_security_group_rule" "lb_public_to_services" {
  for_each = { for service_port in
    distinct(flatten([
      for service_id, service in local.services : [
        for port in service.ports : {
          key  = service_id
          port = port
        }
      ] if service.is_public_facing
    ])) : "${service_port.key}_${service_port.port}" => service_port
  }

  security_group_id        = aws_security_group.services[each.value.key].id
  type                     = "ingress"
  from_port                = each.value.port
  to_port                  = each.value.port
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.load_balancer_public.id
  description              = aws_security_group.load_balancer_public.name
}

# ----------------------------------------------------------
# Load balancer
# ----------------------------------------------------------
resource "aws_security_group" "load_balancer_public" {
  name   = "${var.environment}-${var.indexers[var.region].name}-lb-public-sg"
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "${var.environment}-${var.indexers[var.region].name}-lb-public-sg"
    Environment = "${var.environment}"
  }
}

resource "aws_security_group_rule" "outbound_traffic_from_load_balancer" {
  count             = var.public_access ? 1 : 0
  security_group_id = aws_security_group.load_balancer_public.id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
}

# Ingress rule for HTTP traffic for the load balancer
resource "aws_security_group_rule" "inbound_http_to_load_balancer" {
  count             = var.public_access ? 1 : 0
  security_group_id = aws_security_group.load_balancer_public.id
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
}

# Ingress rule for HTTP traffic for the load balancer - - only created if `var.enable_https` is true
resource "aws_security_group_rule" "inbound_https_to_load_balancer" {
  count             = var.public_access && var.enable_https ? 1 : 0
  security_group_id = aws_security_group.load_balancer_public.id
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
}

# ----------------------------------------------------------
# Lambda Services: Security Groups for Lambda Services
# ----------------------------------------------------------
resource "aws_security_group" "lambda_services" {
  for_each = local.lambda_services

  name   = "${var.environment}-${var.indexers[var.region].name}-${each.key}-sg"
  vpc_id = aws_vpc.main.id

  # Allow ssh in from everywhere.
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound ipv4 traffic.
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.environment}-${var.indexers[var.region].name}-${each.key}-sg"
    Environment = "${var.environment}"
  }
}
