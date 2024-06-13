# Security group for the network.
resource "aws_security_group" "main" {
  name   = "${var.environment}-${var.name}-sg"
  vpc_id = aws_vpc.main.id

  ingress {
    protocol         = "-1"
    from_port        = 0
    to_port          = 0
    cidr_blocks      = []
    ipv6_cidr_blocks = []
  }

  # For outgoing traffic, allow all.
  egress {
    protocol         = "-1"
    from_port        = 0
    to_port          = 0
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name        = "${var.environment}-${var.name}-sg"
    Environment = var.environment
  }
}
