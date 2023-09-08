# Public facing Route Table.
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "${var.environment}-${var.name}-routing-table-public"
    Environment = var.environment
  }
}

# Routing table entry for the internet gateway on the public facing Route Table.
resource "aws_route" "internet_gateway_route" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
}

# Public facing Route Table association with subnet.
resource "aws_route_table_association" "public" {
  for_each = aws_subnet.public

  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}
