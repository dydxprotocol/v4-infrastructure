#!/usr/bin/env bash
set -e
export AWS_PROFILE=dydx-testnet
terraform import \
  -var environment=testnet \
  -var create_read_replica_2=true \
  -var datadog_api_key="$DD_API_KEY" \
  -var datadog_app_key="$DD_APP_KEY" \
  -var rds_db_password=stub \
  'aws_db_instance.read_replica_2[0]' testnet-indexer-apne1-db-read-replica-2
