locals {
  db_engine         = "postgres"
  db_engine_version = "16.8"
}

# Subnets to associate with the RDS instance.
resource "aws_db_subnet_group" "main" {
  name = "${var.environment}-${var.indexers[var.region].name}-db-subnet"
  # Use the first private subnet as the RDS instance will not be publicly accessible,
  # and so the db is always located in the same subnet.
  subnet_ids = [for subnet_name in var.indexers[var.region].rds_availability_regions : aws_subnet.private_subnets[subnet_name].id]

  tags = {
    Name        = "${var.environment}-${var.indexers[var.region].name}-db-subnet"
    Environment = var.environment
  }
}

# DB parameter group for the RDS instance. Sets various Postgres specific parameters for the
# instance.
resource "aws_db_parameter_group" "main" {
  name   = "postgres-16-defaults-no-force-ssl"
  family = "postgres16"

  parameter {
    name  = "autovacuum_naptime"
    value = "60"
  }

  parameter {
    name  = "autovacuum_vacuum_cost_delay"
    value = "10"
  }

  parameter {
    name  = "autovacuum_vacuum_scale_factor"
    value = "0.05"
  }

  parameter {
    name  = "autovacuum_vacuum_threshold"
    value = "4096"
  }

  parameter {
    name  = "checkpoint_timeout"
    value = "3600"
  }

  parameter {
    name  = "checkpoint_warning"
    value = "3000"
  }

  parameter {
    name  = "default_statistics_target"
    value = "500"
  }

  parameter {
    name  = "hot_standby_feedback"
    value = "1"
  }

  parameter {
    name  = "log_lock_waits"
    value = "1"
  }

  parameter {
    name  = "log_min_duration_statement"
    value = "4000"
  }

  parameter {
    name  = "log_recovery_conflict_waits"
    value = "1"
  }

  parameter {
    name  = "log_statement"
    value = "ddl"
  }

  parameter {
    name  = "max_parallel_maintenance_workers"
    value = "8"
  }

  parameter {
    name  = "max_parallel_workers_per_gather"
    value = "4"
  }

  parameter {
    name  = "max_wal_size"
    value = "4096"
  }

  parameter {
    name  = "min_wal_size"
    value = "2048"
  }

  parameter {
    name  = "random_page_cost"
    value = "1.0"
  }

  parameter {
    name  = "pg_stat_statements.track"
    value = "all"
  }

  parameter {
    name  = "rds.force_autovacuum_logging_level"
    value = "INFO"
  }

  parameter {
    name  = "rds.force_ssl"
    value = "0"
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name        = "postgres-16-defaults-no-force-ssl"
    Environment = var.environment
  }
}

locals {
  aws_db_instance_main_name = "${var.environment}-${var.indexers[var.region].name}-db"
}

data "aws_secretsmanager_secret_version" "ender_secrets" {
  secret_id = "${var.environment}-ender-secrets"
}

# RDS instance.
resource "aws_db_instance" "main" {
  allocated_storage                     = var.rds_db_allocated_storage_gb
  auto_minor_version_upgrade            = true
  backup_retention_period               = 3
  db_name                               = local.rds_db_name
  db_subnet_group_name                  = aws_db_subnet_group.main.name
  delete_automated_backups              = false
  deletion_protection                   = true
  enabled_cloudwatch_logs_exports       = ["upgrade"]
  engine                                = local.db_engine
  engine_version                        = local.db_engine_version
  identifier                            = local.aws_db_instance_main_name
  instance_class                        = var.rds_db_instance_class
  monitoring_interval                   = var.rds_monitoring_interval
  multi_az                              = var.enable_rds_main_multiaz
  parameter_group_name                  = aws_db_parameter_group.main.name
  password                              = jsondecode(data.aws_secretsmanager_secret_version.ender_secrets.secret_string)["DB_PASSWORD"]
  performance_insights_enabled          = true
  performance_insights_retention_period = 7
  publicly_accessible                   = false
  skip_final_snapshot                   = true
  username                              = local.rds_username
  vpc_security_group_ids                = [aws_security_group.rds.id]

  # Set to true if any planned changes need to be applied before the next maintenance window.
  apply_immediately = false

  tags = {
    Name        = local.aws_db_instance_main_name
    Environment = "${var.environment}"
  }
}

# Read replica
resource "aws_db_instance" "read_replica" {
  allocated_storage                     = var.rds_db_allocated_storage_gb
  auto_minor_version_upgrade            = true
  deletion_protection                   = true
  identifier                            = "${local.aws_db_instance_main_name}-read-replica"
  instance_class                        = var.rds_db_replica_instance_class
  monitoring_interval                   = coalesce(var.rds_read_replica_monitoring_interval, var.rds_monitoring_interval)
  multi_az                              = false
  parameter_group_name                  = aws_db_parameter_group.main.name
  performance_insights_enabled          = true
  performance_insights_retention_period = 7
  publicly_accessible                   = false
  replicate_source_db                   = aws_db_instance.main.identifier
  skip_final_snapshot                   = true
  vpc_security_group_ids                = [aws_security_group.rds.id]

  # Set to true if any planned changes need to be applied before the next maintenance window.
  apply_immediately = false

  tags = {
    Name        = "${local.aws_db_instance_main_name}-read-replica"
    Environment = "${var.environment}"
  }
}

# Read replica 2
resource "aws_db_instance" "read_replica_2" {
  allocated_storage                     = var.rds_db_allocated_storage_gb
  auto_minor_version_upgrade            = false
  count                                 = var.create_read_replica_2 ? 1 : 0
  deletion_protection                   = true
  identifier                            = "${local.aws_db_instance_main_name}-read-replica-2"
  instance_class                        = var.rds_db_replica_instance_class
  monitoring_interval                   = coalesce(var.rds_read_replica_monitoring_interval, var.rds_monitoring_interval)
  multi_az                              = false
  parameter_group_name                  = aws_db_parameter_group.main.name
  performance_insights_enabled          = true
  performance_insights_retention_period = 31
  publicly_accessible                   = false
  replicate_source_db                   = aws_db_instance.main.identifier
  skip_final_snapshot                   = true
  vpc_security_group_ids                = [aws_security_group.rds.id]

  # Set to true if any planned changes need to be applied before the next maintenance window.
  apply_immediately = false

  tags = {
    Name        = "${local.aws_db_instance_main_name}-read-replica-2"
    Environment = "${var.environment}"
  }
}

resource "aws_db_instance" "read_replica_analytics" {
  allocated_storage                     = var.rds_db_allocated_storage_gb
  auto_minor_version_upgrade            = false
  count                                 = var.create_read_replica_2 ? 1 : 0
  deletion_protection                   = true
  identifier                            = "${local.aws_db_instance_main_name}-read-replica-analytics"
  instance_class                        = var.rds_db_replica_instance_class
  monitoring_interval                   = coalesce(var.rds_read_replica_monitoring_interval, var.rds_monitoring_interval)
  multi_az                              = false
  parameter_group_name                  = aws_db_parameter_group.main.name
  performance_insights_enabled          = true
  performance_insights_retention_period = 31
  publicly_accessible                   = false
  replicate_source_db                   = aws_db_instance.main.identifier
  skip_final_snapshot                   = true
  vpc_security_group_ids                = [aws_security_group.rds.id]

  # Set to true if any planned changes need to be applied before the next maintenance window.
  apply_immediately = false

  tags = {
    Name        = "${local.aws_db_instance_main_name}-read-replica-analytics"
    Environment = "${var.environment}"
  }
}
