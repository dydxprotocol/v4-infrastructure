indexers = {
  ap-northeast-1 = {
    name               = "indexer-apne1"
    availability_zones = ["ap-northeast-1a", "ap-northeast-1c", "ap-northeast-1d"]
    vpc_cidr_block     = "10.0.0.0/16"
    private_subnets_availability_zone_to_cidr_block = {
      "ap-northeast-1a" = "10.0.0.0/24"
      "ap-northeast-1c" = "10.0.1.0/24"
      "ap-northeast-1d" = "10.0.2.0/24"
    }
    public_subnets_availability_zone_to_cidr_block = {
      "ap-northeast-1a" = "10.0.3.0/24"
      "ap-northeast-1c" = "10.0.4.0/24"
      "ap-northeast-1d" = "10.0.5.0/24"
    }
    elb_account_id           = 582318560864
    rds_availability_regions = ["ap-northeast-1c", "ap-northeast-1d"]
  }
}
environment      = "dev"
node_environment = "production"
region           = "ap-northeast-1"
bugsnag_key      = "placeholder value"

elasticache_redis_num_cache_clusters = 2

full_node_name                       = "indexer-full-node"
backup_full_node_name                = "indexer-full-node-backup"
snapshot_full_node_name              = "indexer-full-node-snapshot"
full_node_availability_zones         = ["ap-northeast-1a", "ap-northeast-1c"]
full_node_cidr_vpc                   = "11.0.0.0/16"
full_node_cidr_public_subnets        = ["11.0.1.0/24", "11.0.2.0/24"]
backup_full_node_cidr_vpc            = "12.0.0.0/16"
backup_full_node_cidr_public_subnets = ["12.0.1.0/24", "12.0.2.0/24"]
full_node_tcp_port_to_health_protocol = {
  1317  = "TCP"
  9090  = "TCP"
  26656 = "TCP"
  26657 = "HTTP"
}
# Port 26656 is for Tendermint P2P
full_node_public_ports = ["26656"]
