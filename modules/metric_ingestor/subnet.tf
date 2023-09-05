# Public facing Subnets.
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  map_public_ip_on_launch = true # Assigns a public IP address to instances.
  cidr_block              = aws_vpc.main.cidr_block

  tags = {
    Name        = "${var.environment}-${var.name}-public-subnet"
    Environment = var.environment
  }
}
