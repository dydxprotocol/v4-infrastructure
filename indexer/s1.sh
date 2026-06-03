#!/usr/bin/env bash
set -e
export AWS_PROFILE=dydx-testnet
terraform import -var environment=testnet -var datadog_api_key=stub -var datadog_app_key=stub -var rds_db_password=stub aws_db_parameter_group.main testnet-indexer-apne1-db-parameter-group-postgres-17
