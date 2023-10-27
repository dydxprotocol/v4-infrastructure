locals {
  kafka_version = "2.6.2"
  rds_db_name   = "dydx"
  rds_username  = "dydx"
  rds_port      = 5432
}

locals {
  service_names_list = [
    "ender",
    "comlink",
    "socks",
    "roundtable",
    "vulcan",
  ]
  // Needed so that there are no circular dependencies for all resources are created per service names.
  service_names = {
    for name in local.service_names_list : name => name
  }

  service_secret_ids = {
    for name in local.service_names : name => "${var.environment}-${name}-secrets"
  }
}

locals {
  services = {
    "${local.service_names["ender"]}" : {
      ecs_desired_count : 1,
      task_definition_memory : 8192,
      task_definition_cpu : 4096,
      is_public_facing : false,
      ports : [8080],
      health_check_port : 8080,
      requires_kafka_connection : true,
      requires_postgres_connection : true,
      requires_redis_connection : true,
      should_deploy_in_rds_subnet : true,
      ecs_environment_variables : flatten(
        [
          {
            name : "PG_POOL_MAX",
            value : "30"
          },
          {
            name  = "PG_POOL_MIN",
            value = "10",
          },
          var.ender_ecs_environment_variables,
        ],
      ),
    },
    "${local.service_names["comlink"]}" : {
      ecs_desired_count : 5,
      task_definition_memory : 4096,
      task_definition_cpu : 2048,
      is_public_facing : true,
      ports : [8080],
      health_check_port : 8080,
      requires_kafka_connection : false,
      requires_postgres_connection : true,
      requires_redis_connection : true,
      should_deploy_in_rds_subnet : false,
      ecs_environment_variables : flatten(
        [
          {
            name : "TENDERMINT_WS_URL",
            value : module.full_node_ap_northeast_1.validator_rpc_url,
            }, {
            name : "INDEXER_INTERNAL_IPS"
            value : join(",", [for gateway in aws_nat_gateway.main : gateway.public_ip])
            }, {
            name : "USE_READ_REPLICA"
            value : "true"
            }, {
            name : "INDEXER_LEVEL_GEOBLOCKING_ENABLED",
            value : tostring(var.indexer_level_geoblocking),
            }, {
            name : "RESTRICTED_COUNTRIES",
            value : var.geoblocked_countries,
            }, {
            name : "COMPLIANCE_DATA_CLIENT",
            value : var.indexer_compliance_client,
            }, {
            name : "BLOCKED_ADDRESSES",
            value : var.indexer_compliance_blocklist,
            }, {
            name : "PG_POOL_MAX",
            value : "2"
          },
          {
            name  = "PG_POOL_MIN",
            value = "1",
          },
          var.comlink_ecs_environment_variables,
        ],
      ),
    },
    "${local.service_names["socks"]}" : {
      ecs_desired_count : 5,
      task_definition_memory : 20480,
      task_definition_cpu : 4096,
      is_public_facing : true,
      ports : [8080, 8000],
      health_check_port : 8000,
      requires_kafka_connection : true,
      requires_postgres_connection : true,
      requires_redis_connection : false,
      should_deploy_in_rds_subnet : false,
      ecs_environment_variables : flatten(
        [
          {
            name : "COMLINK_URL",
            value : aws_lb.public.dns_name,
          },
          {
            name : "INDEXER_LEVEL_GEOBLOCKING_ENABLED",
            value : tostring(var.indexer_level_geoblocking),
          },
          {
            name : "RESTRICTED_COUNTRIES",
            value : var.geoblocked_countries,
          },
          {
            name : "PG_POOL_MAX",
            value : "2"
          },
          {
            name  = "PG_POOL_MIN",
            value = "1",
          },
          var.socks_ecs_environment_variables,
        ],
      ),
    },
    "${local.service_names["roundtable"]}" : {
      ecs_desired_count : 5,
      task_definition_memory : 4096,
      task_definition_cpu : 2048,
      is_public_facing : false,
      ports : [8080],
      health_check_port : 8080,
      requires_kafka_connection : true,
      requires_postgres_connection : true,
      requires_redis_connection : true,
      should_deploy_in_rds_subnet : false,
      ecs_environment_variables : flatten(
        [
          {
            name : "AWS_REGION",
            value : var.region,
          },
          {
            name : "AWS_ACCOUNT_ID",
            value : local.account_id,
          },
          {
            name : "KMS_KEY_ARN",
            value : aws_kms_key.rds_export.arn,
          },
          {
            name : "ECS_TASK_ROLE_ARN",
            value : module.iam_service_ecs_task_roles["roundtable"].ecs_task_role_arn,
          },
          {
            name : "S3_BUCKET_ARN",
            value : aws_s3_bucket.athena_rds_snapshots.arn,
          },
          {
            name  = "RDS_INSTANCE_NAME",
            value = local.aws_db_instance_main_name,
          },
          {
            name : "COMPLIANCE_DATA_CLIENT",
            value : var.indexer_compliance_client,
          },
          {
            name : "BLOCKED_ADDRESSES",
            value : var.indexer_compliance_blocklist,
          },
          {
            name : "PG_POOL_MAX",
            value : "2"
          },
          {
            name  = "PG_POOL_MIN",
            value = "1",
          },
          var.roundtable_ecs_environment_variables,
        ],
      ),
    },
    "${local.service_names["vulcan"]}" : {
      ecs_desired_count : 5,
      task_definition_memory : 8192,
      task_definition_cpu : 4096,
      is_public_facing : false,
      ports : [8080],
      health_check_port : 8080,
      requires_kafka_connection : true,
      requires_postgres_connection : true,
      requires_redis_connection : true,
      should_deploy_in_rds_subnet : false,
      ecs_environment_variables : flatten(
        [
          {
            name : "PG_POOL_MAX",
            value : "2"
          },
          {
            name  = "PG_POOL_MIN",
            value = "1",
          },
          var.vulcan_ecs_environment_variables,
        ],
      ),
    },
  }
  postgres_environment_variables = [
    {
      name  = "DB_NAME",
      value = local.rds_db_name,
    },
    {
      name  = "DB_USERNAME",
      value = local.rds_username,
    },
    {
      name  = "DB_PASSWORD",
      value = var.rds_db_password,
    },
    {
      name  = "DB_HOSTNAME",
      value = aws_db_instance.main.address,
    },
    {
      name  = "DB_READONLY_HOSTNAME",
      value = aws_db_instance.read_replica.address,
    },
    {
      name  = "DB_PORT",
      value = local.rds_port,
    },
  ]
  kafka_environment_variables = [
    {
      name  = "KAFKA_BROKER_URLS",
      value = aws_msk_cluster.main.bootstrap_brokers,
    },
  ]
  redis_environment_variables = [
    {
      name  = "REDIS_URL",
      value = "redis://${aws_elasticache_replication_group.main.primary_endpoint_address}:${aws_elasticache_replication_group.main.port}",
    },
    {
      name  = "RATE_LIMIT_REDIS_URL",
      value = "redis://${aws_elasticache_replication_group.rate_limit.primary_endpoint_address}:${aws_elasticache_replication_group.rate_limit.port}"
    }
  ]
  lambda_services = {
    "bazooka" : {
      requires_postgres_connection : true,
      requires_redis_connection : true,
      requires_kafka_connection : true,
      requires_upgrade_indexer_iam_policies : false,
      environment_variables : {
        PREVENT_BREAKING_CHANGES_WITHOUT_FORCE : var.prevent_breaking_changes_without_force,
      },
    },
    "auxo" : {
      requires_postgres_connection : false,
      requires_redis_connection : false,
      requires_kafka_connection : false,
      requires_upgrade_indexer_iam_policies : true,
      environment_variables : {},
    }
  }
}

# Taken from https://github.com/dydxprotocol/indexer/blob/master/packages/base/src/logger.ts#L22
locals {
  log_levels = ["emerg", "alert", "crit", "error", "warning", "notice", "info", "debug"]
}

locals {
  # TODO(CLOB-664): Reduce access permissions for indexer ECS task role.
  indexer_ecs_task_role_policies = [
    {
      name  = "Athena Policy",
      value = "arn:aws:iam::aws:policy/AmazonAthenaFullAccess",
    },
    {
      name  = "S3 Policy",
      value = "arn:aws:iam::aws:policy/AmazonS3FullAccess",
    },
    {
      name  = "RDS Policy",
      value = "arn:aws:iam::aws:policy/AmazonRDSFullAccess",
    },
    {
      name  = "KMS Policy",
      value = aws_iam_policy.kms_policy.arn,
    }
  ]
}

locals {
  node_ecr_repository_url          = var.environment == "mainnet" ? data.aws_ecr_repository.full_node_ap_northeast_1[0].repository_url : data.aws_ecr_repository.full_node_us_east_2[0].repository_url
  snapshot_node_ecr_repository_url = var.environment == "mainnet" ? data.aws_ecr_repository.snapshot_full_node_ap_northeast_1[0].repository_url : data.aws_ecr_repository.snapshot_full_node_us_east_2[0].repository_url
}
