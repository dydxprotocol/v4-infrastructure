resource "aws_elasticache_subnet_group" "main" {
  count      = local.indexer_enabled ? 1 : 0
  name       = "${var.environment}-${var.indexers[var.region].name}-elasticache-subnet-group"
  subnet_ids = [for subnet in aws_subnet.private_subnets : subnet.id]

  tags = {
    name        = "${var.environment}-${var.indexers[var.region].name}-elasticache-subnet-group"
    environment = var.environment
  }
}

// Elasticache Redis for all caching and storage of indexer off chain data.
resource "aws_elasticache_replication_group" "main" {
  count                      = local.indexer_enabled ? 1 : 0
  automatic_failover_enabled = true
  multi_az_enabled           = true
  replication_group_id       = "${var.environment}-${var.indexers[var.region].name}-redis"
  description                = "Redis main cluster"
  num_cache_clusters         = var.elasticache_redis_num_cache_clusters
  node_type                  = var.elasticache_redis_node_type
  engine                     = "valkey"
  engine_version             = "8.0"
  parameter_group_name       = var.elasticache_redis_parameter_group_name
  security_group_ids         = [aws_security_group.redis[0].id]
  port                       = 6379
  subnet_group_name          = aws_elasticache_subnet_group.main[0].name

  tags = {
    name        = "${var.environment}-${var.indexers[var.region].name}-redis"
    environment = var.environment
  }

  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_elasticache_subnet_group" "rate_limit" {
  count      = local.indexer_enabled ? 1 : 0
  name       = "${var.environment}-${var.indexers[var.region].name}-elasticache-rate-limit-subnet-group"
  subnet_ids = [for subnet in aws_subnet.private_subnets : subnet.id]

  tags = {
    name        = "${var.environment}-${var.indexers[var.region].name}-elasticache-rate-limit-subnet-group"
    environment = var.environment
  }
}

// Elasticache Redis for rate-limits
resource "aws_elasticache_replication_group" "rate_limit" {
  count                      = local.indexer_enabled ? 1 : 0
  automatic_failover_enabled = true
  multi_az_enabled           = true
  replication_group_id       = "${var.environment}-${var.indexers[var.region].name}-rate-limit-redis"
  description                = "Redis rate-limit cluster"
  num_cache_clusters         = coalesce(var.elasticache_rate_limit_redis_num_cache_clusters, var.elasticache_redis_num_cache_clusters)
  node_type                  = coalesce(var.elasticache_rate_limit_redis_node_type, var.elasticache_redis_node_type)
  engine                     = "valkey"
  engine_version             = "8.0"
  parameter_group_name       = coalesce(var.elasticache_rate_limit_redis_parameter_group_name, var.elasticache_redis_parameter_group_name)
  security_group_ids         = [aws_security_group.redis[0].id]
  port                       = 6379
  subnet_group_name          = aws_elasticache_subnet_group.rate_limit[0].name

  tags = {
    name        = "${var.environment}-${var.indexers[var.region].name}-rate-limit-redis"
    environment = var.environment
  }
}
