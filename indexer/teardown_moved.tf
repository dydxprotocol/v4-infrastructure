# Address migrations for the indexer_enabled teardown gate.
# Adding `count` to a previously count-less resource changes its address
# (foo.bar -> foo.bar[0]); these moved blocks keep existing state (all
# environments default indexer_enabled=true) from proposing destroy+recreate.

moved {
  from = aws_glue_catalog_database.rds_snapshots
  to   = aws_glue_catalog_database.rds_snapshots[0]
}

moved {
  from = aws_cloudformation_stack.datadog_forwarder
  to   = aws_cloudformation_stack.datadog_forwarder[0]
}

moved {
  from = aws_ecs_cluster.main
  to   = aws_ecs_cluster.main[0]
}

moved {
  from = aws_iam_policy.kms_policy
  to   = aws_iam_policy.kms_policy[0]
}

moved {
  from = aws_kms_key.rds_export
  to   = aws_kms_key.rds_export[0]
}

moved {
  from = aws_iam_policy.lambda_upgrade_indexer_policy
  to   = aws_iam_policy.lambda_upgrade_indexer_policy[0]
}

moved {
  from = aws_iam_policy.ecs_task_s3_policy
  to   = aws_iam_policy.ecs_task_s3_policy[0]
}

moved {
  from = aws_lb.public
  to   = aws_lb.public[0]
}

moved {
  from = aws_lb_listener.public_http
  to   = aws_lb_listener.public_http[0]
}

moved {
  from = aws_lb_listener_rule.public_http_socks
  to   = aws_lb_listener_rule.public_http_socks[0]
}

moved {
  from = aws_lb_listener_rule.public_http_comlink
  to   = aws_lb_listener_rule.public_http_comlink[0]
}

moved {
  from = aws_msk_configuration.main
  to   = aws_msk_configuration.main[0]
}

moved {
  from = aws_msk_cluster.main
  to   = aws_msk_cluster.main[0]
}

moved {
  from = aws_network_acl.public
  to   = aws_network_acl.public[0]
}

moved {
  from = aws_network_acl_rule.public_egress_allow_all
  to   = aws_network_acl_rule.public_egress_allow_all[0]
}

moved {
  from = aws_network_acl_rule.public_ingress_allow_all_from_vpc
  to   = aws_network_acl_rule.public_ingress_allow_all_from_vpc[0]
}

moved {
  from = aws_network_acl_rule.public_ingress_allow_all_tcp
  to   = aws_network_acl_rule.public_ingress_allow_all_tcp[0]
}

moved {
  from = aws_network_acl_rule.public_ingress_allow_all_udp
  to   = aws_network_acl_rule.public_ingress_allow_all_udp[0]
}

moved {
  from = aws_network_acl_rule.public_ingress_allow_ssh
  to   = aws_network_acl_rule.public_ingress_allow_ssh[0]
}

moved {
  from = aws_network_acl.private
  to   = aws_network_acl.private[0]
}

moved {
  from = aws_network_acl_rule.private_egress_allow_all
  to   = aws_network_acl_rule.private_egress_allow_all[0]
}

moved {
  from = aws_network_acl_rule.private_ingress_allow_all_from_vpc
  to   = aws_network_acl_rule.private_ingress_allow_all_from_vpc[0]
}

moved {
  from = aws_network_acl_rule.private_ingress_allow_all_tcp
  to   = aws_network_acl_rule.private_ingress_allow_all_tcp[0]
}

moved {
  from = aws_network_acl_rule.private_ingress_allow_all_udp
  to   = aws_network_acl_rule.private_ingress_allow_all_udp[0]
}

moved {
  from = aws_network_acl_rule.private_ingress_allow_ssh
  to   = aws_network_acl_rule.private_ingress_allow_ssh[0]
}

moved {
  from = aws_route53_zone.main
  to   = aws_route53_zone.main[0]
}

moved {
  from = aws_db_subnet_group.main
  to   = aws_db_subnet_group.main[0]
}

moved {
  from = aws_db_parameter_group.main
  to   = aws_db_parameter_group.main[0]
}

moved {
  from = aws_db_instance.main
  to   = aws_db_instance.main[0]
}

moved {
  from = aws_route_table.public
  to   = aws_route_table.public[0]
}

moved {
  from = aws_route.public
  to   = aws_route.public[0]
}

moved {
  from = aws_route.full_node_route_to_indexer
  to   = aws_route.full_node_route_to_indexer[0]
}

moved {
  from = aws_security_group.rds
  to   = aws_security_group.rds[0]
}

moved {
  from = aws_security_group.msk
  to   = aws_security_group.msk[0]
}

moved {
  from = aws_security_group.redis
  to   = aws_security_group.redis[0]
}

moved {
  from = aws_security_group.devbox
  to   = aws_security_group.devbox[0]
}

moved {
  from = aws_security_group.load_balancer_public
  to   = aws_security_group.load_balancer_public[0]
}

moved {
  from = aws_s3_bucket.load_balancer
  to   = aws_s3_bucket.load_balancer[0]
}

moved {
  from = aws_s3_bucket_metric.indexer_full_node_snapshots
  to   = aws_s3_bucket_metric.indexer_full_node_snapshots[0]
}

moved {
  from = aws_s3_bucket_policy.lb_s3_bucket_policy
  to   = aws_s3_bucket_policy.lb_s3_bucket_policy[0]
}

moved {
  from = aws_s3_bucket.indexer_full_node_snapshots
  to   = aws_s3_bucket.indexer_full_node_snapshots[0]
}

moved {
  from = aws_s3_bucket.athena_rds_snapshots
  to   = aws_s3_bucket.athena_rds_snapshots[0]
}

moved {
  from = aws_vpc.main
  to   = aws_vpc.main[0]
}

moved {
  from = aws_internet_gateway.main
  to   = aws_internet_gateway.main[0]
}

moved {
  from = aws_vpc_peering_connection.full_node_peer
  to   = aws_vpc_peering_connection.full_node_peer[0]
}

moved {
  from = aws_elasticache_subnet_group.main
  to   = aws_elasticache_subnet_group.main[0]
}

moved {
  from = aws_elasticache_replication_group.main
  to   = aws_elasticache_replication_group.main[0]
}

moved {
  from = aws_elasticache_subnet_group.rate_limit
  to   = aws_elasticache_subnet_group.rate_limit[0]
}

moved {
  from = aws_elasticache_replication_group.rate_limit
  to   = aws_elasticache_replication_group.rate_limit[0]
}

moved {
  from = module.datadog_agent
  to   = module.datadog_agent[0]
}

moved {
  from = module.iam_ecs_task_roles
  to   = module.iam_ecs_task_roles[0]
}

moved {
  from = module.iam_github_actions
  to   = module.iam_github_actions[0]
}

moved {
  from = module.full_node_ap_northeast_1
  to   = module.full_node_ap_northeast_1[0]
}

moved {
  from = module.full_node_snapshot_ap_northeast_1
  to   = module.full_node_snapshot_ap_northeast_1[0]
}
