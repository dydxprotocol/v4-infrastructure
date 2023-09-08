# Main VPC for the region.
resource "aws_vpc" "main" {
  cidr_block = var.cidr_vpc

  # DNS settings: instances with public IP receive public DNS hostnames.
  # https://docs.aws.amazon.com/vpc/latest/userguide/vpc-dns.html
  enable_dns_support   = true # default value for default VPC
  enable_dns_hostnames = true # default value

  tags = {
    Name        = "${var.environment}-${var.name}-vpc"
    Environment = var.environment
  }
}

# Internet Gateway to connect VPC to the internet.
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "${var.environment}-${var.name}-igw"
    Environment = var.environment
  }
}
