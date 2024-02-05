locals {
  db_engine         = "postgres"
  db_engine_version = "12.14"
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
  name   = "${var.environment}-${var.indexers[var.region].name}-db-parameter-group"
  family = "postgres12"

  # Matches v3.
  # Logs each successful connection.
  # Enabled for better monitoring from logs.
  # More details: https://postgresqlco.nf/doc/en/param/log_connections/
  parameter {
    name  = "log_connections"
    value = "1" # Default is off.
  }

  # Matches v3.
  # Time to sleep between autovacuum runs in seconds. Minimum delay bewteen autovacuum runs.
  # Decreased so autovacuum runs more frequently and locks the database for shorter periods of time.
  # More details: https://postgresqlco.nf/doc/en/param/autovacuum_naptime/
  parameter {
    name  = "autovacuum_naptime"
    value = "10" # Default is 15.
  }

  # Matches v3.
  # Cost delay for autovacuum runs in ms.
  # Decreased to have more autovacuums for shorter periods of time.
  # More details: https://postgresqlco.nf/doc/en/param/autovacuum_vacuum_cost_delay/
  parameter {
    name  = "autovacuum_vacuum_cost_delay"
    value = "1" # Default is 2.
  }

  # Matches v3.
  # Cost limit before vacuuming stops, and sleeps for `autovacuum_cost_delay`.
  # Decreased to have autovacuums last for shorter periods of time.
  # More details: https://postgresqlco.nf/doc/en/param/autovacuum_vacuum_cost_limit/
  parameter {
    name  = "autovacuum_vacuum_cost_limit"
    value = "80" # Default is 200.
  }

  # Matches v3.
  # Number of tuple updates or deletes prior to a vacuum as a fraction of reltuples.
  # Decreased to have autovacuum trigger more often for shorter periods of time.
  # More details: https://postgresqlco.nf/doc/en/param/autovacuum_vacuum_scale_factor/
  parameter {
    name  = "autovacuum_vacuum_scale_factor"
    value = "0.05" # Default is 0.2.
  }

  # Matches v3.
  # Minimum number of tuple updates or deletes prior to a vacuum.
  # Increase to account for the amount of data stored in the database.
  # More details: https://postgresqlco.nf/doc/en/param/autovacuum_vacuum_threshold/
  parameter {
    name  = "autovacuum_vacuum_threshold"
    value = "1000" # Default is 50.
  }

  # Matches v3.
  # Maximum time between WAL checkpoints in seconds.
  # Increase to make checkpointing done less frequently to reduce frequency of slow-downs of
  # database operations due to checkpoints.
  # More details: https://postgresqlco.nf/doc/en/param/checkpoint_timeout/
  parameter {
    name  = "checkpoint_timeout"
    value = "3600" # Default is 300.
  }

  # Matches v3.
  # Sets the maximum time before warning if checkpoints triggered by WAL volume happen too
  # frequently in seconds.
  # Increase to match the increase in checkpoint_timeout.
  # More details: https://postgresqlco.nf/doc/en/param/checkpoint_warning/
  parameter {
    name  = "checkpoint_warning"
    value = "3000" # Default is 30.
  }

  # Matches v3.
  # Sets the minimum execution time in ms above which autovacuum actions will be logged.
  # Decreased to account for other autovacuum setttings meant to reduce the average period of time
  # spent autovacuuming.
  # More details: https://postgresqlco.nf/doc/en/param/log_autovacuum_min_duration/
  parameter {
    name  = "log_autovacuum_min_duration"
    value = "60000" # Default is 600_000 (10 minutes)
  }

  # Matches v3.
  # Enable logging of long lock waits.
  # Better monitoring for DB lock conflicts / dead-locks.
  # More details: https://postgresqlco.nf/doc/en/param/log_lock_waits/
  parameter {
    name  = "log_lock_waits"
    value = "1" # Default is -1 (disabled).
  }

  # Matches v3.
  # Sets the minimum execution time above which all statements will be logged in ms.
  # Better monitoring for long-running DB statements.
  # More details: https://postgresqlco.nf/doc/en/param/log_min_duration_statement/
  parameter {
    name  = "log_min_duration_statement"
    value = "30000" # Default is -1 (disabled). Set to 30s.
  }

  # Matches v3.
  # Sets the type of statements logged.
  # Log DDL statements which are not frequent, allows checking of migrations.
  # More details: https://postgresqlco.nf/doc/en/param/log_statement/
  parameter {
    name  = "log_statement"
    value = "ddl" # Default is none.
  }

  # Matches v3.
  # Sets the WAL size that triggers a checkpoint in MB.
  # Increased to reduce the frequency of checkpointing, to reduce frequency of slow-downs of
  # database operations due to checkpointing.
  # More details: https://postgresqlco.nf/doc/en/param/max_wal_size/
  parameter {
    name  = "max_wal_size"
    value = "262144" # Default is 1024.
  }

  # Matches v3.
  # Sets minimum size to shrink the WAL to in MB.
  # Increased as max wal size is also increased.
  # More details: https://postgresqlco.nf/doc/en/param/min_wal_size/
  parameter {
    name  = "min_wal_size"
    value = "4096" # Default is 80.
  }

  # Matches v3.
  # Sets planner estimate of cost of a nonsequentially fetched disk page.
  # Decreased to reduce the importance of disk I/O vs CPU costs.
  # More details: https://postgresqlco.nf/doc/en/param/random_page_cost/
  parameter {
    name  = "random_page_cost"
    value = "1.0" # Default is 4.
  }

  # Sets statistics tracking to record nested statements (such as statements
  # invoked within functions).
  # More details: https://www.postgresql.org/docs/12/pgstatstatements.html
  parameter {
    name  = "pg_stat_statements.track"
    value = "all" # Default is top.
  }

  tags = {
    Name        = "${var.environment}-${var.indexers[var.region].name}-db-parameter-group"
    Environment = var.environment
  }
}

locals {
  aws_db_instance_main_name = "${var.environment}-${var.indexers[var.region].name}-db"
}

# RDS instance.
resource "aws_db_instance" "main" {
  identifier        = local.aws_db_instance_main_name
  instance_class    = var.rds_db_instance_class
  allocated_storage = var.rds_db_allocated_storage_gb
  engine            = local.db_engine
  engine_version    = local.db_engine_version
  db_name           = local.rds_db_name
  username          = local.rds_username
  # DB password is a sensitive variable passed in via the Terraform Workspace.
  password               = var.rds_db_password
  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.rds.id]
  parameter_group_name   = aws_db_parameter_group.main.name
  publicly_accessible    = false
  # Set to true if any planned changes need to be applied before the next maintenance window.
  apply_immediately                     = false
  skip_final_snapshot                   = true
  backup_retention_period               = 7
  delete_automated_backups              = false
  performance_insights_enabled          = true
  performance_insights_retention_period = 31
  auto_minor_version_upgrade            = false

  tags = {
    Name        = local.aws_db_instance_main_name
    Environment = "${var.environment}"
  }
}

# Read replica
resource "aws_db_instance" "read_replica" {
  identifier     = "${local.aws_db_instance_main_name}-read-replica"
  instance_class = var.rds_db_instance_class
  # engine, engine_version, name, username, db_subnet_group_name, allocated_storage do not have to
  # be specified for a replica, and will match the properties on the source db.
  vpc_security_group_ids = [aws_security_group.rds.id]
  parameter_group_name   = aws_db_parameter_group.main.name
  publicly_accessible    = false
  # Set to true if any planned changes need to be applied before the next maintenance window.
  apply_immediately                     = false
  skip_final_snapshot                   = true
  performance_insights_enabled          = true
  performance_insights_retention_period = 31
  auto_minor_version_upgrade            = false

  replicate_source_db = aws_db_instance.main.identifier

  tags = {
    Name        = "${local.aws_db_instance_main_name}-read-replica"
    Environment = "${var.environment}"
  }
}
