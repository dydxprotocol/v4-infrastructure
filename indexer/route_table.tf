# Public facing Route Table.
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "${var.environment}-${var.indexers[var.region].name}-routing-table-public"
    Environment = var.environment
  }
}

resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
}

# Public facing Route Table association with subnet.
# NOTE: This is not an individual AWS resource, but rather an attachment to the route table, and so
# no tags are added.
resource "aws_route_table_association" "public" {
  for_each = aws_subnet.public_subnets

  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

# Private facing Route Tables.
resource "aws_route_table" "private" {
  for_each = toset(var.indexers[var.region].availability_zones)
  vpc_id   = aws_vpc.main.id

  tags = {
    Name        = "${var.environment}-${var.indexers[var.region].name}-${each.key}-routing-table-private"
    Environment = var.environment
  }
}

resource "aws_route" "private" {
  for_each = aws_route_table.private

  route_table_id         = each.value.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.main[each.key].id
}

# Private facing Route Tables association with subnet.
# NOTE: This is not an individual AWS resource, but rather an attachment to the route table, and so
# no tags are added.
resource "aws_route_table_association" "private" {
  for_each = aws_subnet.private_subnets

  subnet_id      = each.value.id
  route_table_id = aws_route_table.private[each.key].id
}

# Route from the full node's VPC to the Indexer's VPC. Needed so that the full node can connect to
# the brokers for the Indexer's MSK cluster.
# NOTE: This is not an individual AWS resource, but rather an attachment to the route table, and so
# no tags are added.
resource "aws_route" "full_node_route_to_indexer" {
  route_table_id            = module.full_node_ap_northeast_1.route_table_id
  destination_cidr_block    = var.indexers[var.region].vpc_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.full_node_peer.id
}

# Route from the backup full node's VPC to the Indexer's VPC. Needed so that the backup full node can connect to
# the brokers for the Indexer's MSK cluster.
# NOTE: This is not an individual AWS resource, but rather an attachment to the route table, and so
# no tags are added.
resource "aws_route" "backup_full_node_route_to_indexer" {
  count                     = var.create_backup_full_node ? 1 : 0
  route_table_id            = module.backup_full_node_ap_northeast_1[0].route_table_id
  destination_cidr_block    = var.indexers[var.region].vpc_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.backup_full_node_peer[0].id
}

# Route from the Indexer's private subnets to the full node's VPC. Needed so that the full node can
# connect to the brokers for the Indexer's MSK cluster. The MSK cluster has brokers in all 3 private
# subnets, so a route has to be added to each private route table associated with the private
# subnets.
# NOTE: This is not an individual AWS resource, but rather an attachment to the route table, and so
# no tags are added.
resource "aws_route" "indexer_route_to_full_node" {
  for_each = aws_route_table.private

  route_table_id            = each.value.id
  destination_cidr_block    = var.full_node_cidr_vpc
  vpc_peering_connection_id = aws_vpc_peering_connection.full_node_peer.id
}

resource "aws_route" "indexer_route_to_backup_full_node" {
  for_each = var.create_backup_full_node ? aws_route_table.private : {}

  route_table_id            = each.value.id
  destination_cidr_block    = var.backup_full_node_cidr_vpc
  vpc_peering_connection_id = aws_vpc_peering_connection.backup_full_node_peer[0].id
}
