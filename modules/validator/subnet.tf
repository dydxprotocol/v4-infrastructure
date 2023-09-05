# Public facing Subnets.
resource "aws_subnet" "public" {
  for_each = local.availability_zone_to_public_subnet_cidr

  vpc_id                  = aws_vpc.main.id
  cidr_block              = each.value
  availability_zone       = each.key
  map_public_ip_on_launch = true # Assigns a public IP address to instances.

  tags = {
    Name        = "${var.environment}-${var.name}-public-subnet"
    Environment = var.environment
  }
}
