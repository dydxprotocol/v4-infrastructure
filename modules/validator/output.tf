# Outputs the url and port for the node's RPC endpoint. Used by the indexer to connect to node.
output "validator_rpc_url" {
  # 26657 is the default cosmos port for the RPC endpoint
  value = "${aws_instance.validator_ec2_instance.public_ip}:26657"
}

# Outputs the id of the security group for the node. This is the security group attached to the EC2
# instance for the node. Used by the indexer to enable the node to connect to the Indexer MSK
# cluster.
output "aws_security_group_id" {
  value = aws_security_group.main.id
}

# Outputs the id of the VPC for the node. Used to peer the VPC of a node and an Indexer to enable
# the node to connect to the Indexer MSK cluster.
output "aws_vpc_id" {
  value = aws_vpc.main.id
}

# Outputs the id of the route table for the node. Used to add entries in the node and an Indexer's
# route table to enable the node to connect to the Indexer MSK cluster.
output "route_table_id" {
  value = aws_route_table.public.id
}
