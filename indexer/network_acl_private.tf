# -----------------------------------------------------------------------------
# Network ACL private subnets
# -----------------------------------------------------------------------------
resource "aws_network_acl" "private" {
  vpc_id     = aws_vpc.main.id
  subnet_ids = [for subnet in aws_subnet.private_subnets : subnet.id]

  tags = {
    Name        = "${var.environment}-${var.indexers[var.region].name}-private-network-acl"
    Environment = var.environment
  }
}

# ACL rules are processed in order by rule_number and should be sorted as such

# -----------------------------------------------------------------------------
# Egress ACL rules for private subnets
# -----------------------------------------------------------------------------
# Allow all outgoing messages from public subnets
# TODO(DEC-900): Investigate if further restricting ACL rules
resource "aws_network_acl_rule" "private_egress_allow_all" {
  network_acl_id = aws_network_acl.private.id
  rule_number    = 50
  egress         = true
  protocol       = "-1"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
}

# -----------------------------------------------------------------------------
# Ingress ACL rules for private subnets
# -----------------------------------------------------------------------------
# Allow all incoming messages from within VPC
# TODO(DEC-900): Investigate if further restricting ACL rules
resource "aws_network_acl_rule" "private_ingress_allow_all_from_vpc" {
  network_acl_id = aws_network_acl.private.id
  rule_number    = 50
  egress         = false
  protocol       = "-1"
  rule_action    = "allow"
  cidr_block     = aws_vpc.main.cidr_block
}

# Allow all incoming TCP messages from port 79 to 65535
# TODO(DEC-900): Investigate if further restricting ACL rules
resource "aws_network_acl_rule" "private_ingress_allow_all_tcp" {
  network_acl_id = aws_network_acl.private.id
  rule_number    = 100
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 79
  to_port        = 65535
}

# Allow all incoming UDP messages from port 79 to 65535
# TODO(DEC-900): Investigate if further restricting ACL rules
resource "aws_network_acl_rule" "private_ingress_allow_all_udp" {
  network_acl_id = aws_network_acl.private.id
  rule_number    = 110
  egress         = false
  protocol       = "udp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 79
  to_port        = 65535
}

# Allow all incoming SSH from port 22
# TODO(DEC-900): Investigate if further restricting ACL rules
resource "aws_network_acl_rule" "private_ingress_allow_ssh" {
  network_acl_id = aws_network_acl.private.id
  rule_number    = 120
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 22
  to_port        = 22
}

