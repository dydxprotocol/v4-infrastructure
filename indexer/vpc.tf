# Main VPC for the indexer components in the region
resource "aws_vpc" "main" {
  count                = var.indexer_enabled ? 1 : 0
  cidr_block           = var.indexers[var.region].vpc_cidr_block
  enable_dns_hostnames = true
  tags = {
    Name        = "${var.environment}-${var.indexers[var.region].name}-vpc"
    Environment = var.environment
  }
}

# Public facing subnet.
resource "aws_subnet" "private_subnets" {
  for_each = local.azs

  vpc_id            = aws_vpc.main[0].id
  cidr_block        = var.indexers[var.region].private_subnets_availability_zone_to_cidr_block[each.key]
  availability_zone = each.key
  tags = {
    Name        = "${var.environment}-${var.indexers[var.region].name}-private-${each.key}"
    Environment = var.environment
  }
}

# Private facing subnet.
resource "aws_subnet" "public_subnets" {
  for_each = local.azs

  vpc_id            = aws_vpc.main[0].id
  cidr_block        = var.indexers[var.region].public_subnets_availability_zone_to_cidr_block[each.key]
  availability_zone = each.key
  tags = {
    Name        = "${var.environment}-${var.indexers[var.region].name}-public-${each.key}"
    Environment = var.environment
  }
}

# Internet Gateway to connect VPC to the internet.
resource "aws_internet_gateway" "main" {
  count  = var.indexer_enabled ? 1 : 0
  vpc_id = aws_vpc.main[0].id

  tags = {
    Name        = "${var.environment}-${var.indexers[var.region].name}-igw"
    Environment = var.environment
  }
}

# NAT Gateways to connect private subnets to the internet.
resource "aws_nat_gateway" "main" {
  for_each = aws_subnet.public_subnets

  subnet_id     = each.value.id
  allocation_id = aws_eip.main[each.key].allocation_id

  tags = {
    Name        = "${var.environment}-${var.indexers[var.region].name}-${each.key}-nat-gateway"
    Environment = var.environment
  }
}

# Elastic IP Addresses for the NAT Gateway
resource "aws_eip" "main" {
  for_each = local.azs

  tags = {
    Name        = "${var.environment}-${var.indexers[var.region].name}-${each.key}-nat-gateway-eip"
    Environment = var.environment
  }
}

# VPC Peer resource between the Indexer and a full node's VPC
resource "aws_vpc_peering_connection" "full_node_peer" {
  count       = var.indexer_enabled ? 1 : 0
  peer_vpc_id = aws_vpc.main[0].id
  vpc_id      = module.full_node_ap_northeast_1[0].aws_vpc_id
  # Auto-accept allows the VPC peering connection to be made programmatically with no manual steps
  # to accept the VPC peering connection in the console
  # This can only be done if both VPCs are in the same region and AWS account (which they are)
  auto_accept = true

  tags = {
    Name        = "${var.environment}-${var.indexers[var.region].name}-vpc-peering-connection"
    Environment = var.environment
  }
}

resource "aws_vpc_peering_connection" "backup_full_node_peer" {
  count       = var.indexer_enabled && var.create_backup_full_node ? 1 : 0
  peer_vpc_id = aws_vpc.main[0].id
  vpc_id      = module.backup_full_node_ap_northeast_1[0].aws_vpc_id
  # Auto-accept allows the VPC peering connection to be made programmatically with no manual steps
  # to accept the VPC peering connection in the console
  # This can only be done if both VPCs are in the same region and AWS account (which they are)
  auto_accept = true

  tags = {
    Name        = "${var.environment}-${var.indexers[var.region].name}-vpc-peering-connection"
    Environment = var.environment
  }
}
