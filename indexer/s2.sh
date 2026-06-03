export AWS_PROFILE=dydx-testnet
terraform import \
    -var environment=testnet \
    -var datadog_api_key="$DD_API_KEY" \
    -var datadog_app_key="$DD_APP_KEY" \
    -var rds_db_password=stub \
    aws_db_parameter_group.main testnet-indexer-apne1-db-parameter-group-postgres-17
