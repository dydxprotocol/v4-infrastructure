# Metric Ingestor

The Metric Ingestor module uses the Datadog Agent container running on ECS in daemon mode to
consume metrics from external hosts running prometheus endpoints. The Metric Ingestor does not
consume metrics for private/internal hosts such as validators or full nodes running on our
own infrastructure. (Those hosts have their own Datadog sidecars. See the `validator` module for
more information.)

Metric Ingestor runs in Daemon mode to take advantage of public EIP. This is useful if an external
party wishes to whitelist our IP.

Validators provided in the config are scraped by the Datadog Agent via two custom checks:

- `chain_metadata`: Emits metrics that track the voting power of all validators in the active set. Also it saves the monikers of all validators to a file that can be used by the `validator_metrics` check.
- `validator_metrics`: Extends the `OpenMetricsBaseCheck` class to scrape metrics from multiple endpoints and decorate them with additional tags.

The user should provide the following Terraform variables:

- `chain_metadata_node_base_url`: The base URL of the chain metadata node. E.g.: `https://dydx-testnet-api.polkachu.com`
- `datadog_api_key`: The Datadog API key.
- `datadog_app_key`: The Datadog app key.
- `datadog_site`: The Datadog site. E.g.: `ap1.datadoghq.com`
- `enabled`: Whether to enable the Metric Ingestor (`true` or `false`).
- `environment`: The environment the Metric Ingestor is running in. E.g.: `testnet`
- `region`: The region the Metric Ingestor is running in. E.g.: `ap-northeast-1`
- `validators`: A list of validators to scrape. See below.

Also the following `env` variables are required if using Terraform Cloud:

- `TFC_AWS_PROVIDER_AUTH`: The AWS provider auth.
- `TFC_AWS_RUN_ROLE_ARN`: The AWS run role ARN.

Validators to scrape are configured via the `validators` variable, like this:

```hcl
[
  {
    address = "dydxvaloper1mscvgg4g6yqwsep4elhg8a8z874fyafyc9nn3r", 
    openmetrics_endpoint = "http://13.230.43.253:26660",
    endpoint_type = "dydx",
    machine_id = "lorem",
  },
  {
    address = "dydxvaloper1mscvgg4g6yqwsep4elhg8a8z874fyafyc9nn3r", 
    openmetrics_endpoint = "http://13.230.43.253:26660",
    endpoint_type = "dydx",
    machine_id = "ipsum",
  },
  {
    address = "dydxvaloper1mscvgg4g6yqwsep4elhg8a8z874fyafyc9nn3r", 
    openmetrics_endpoint = "http://13.230.43.253:8002",
    endpoint_type = "slinky",
  },
]
```

The `address` is the validator's operator address.

The `openmetrics_endpoint` is the endpoint to scrape metrics from.

The `endpoint_type` is the type of endpoint. E.g.: `dydx` or `slinky`.

The `machine_id` is used to identify the validator's node in special cases, e.g. when using 2 machines for redundancy, with Horcrux, to run a single validator. For most cases, this can be omitted. If it is provided, the emitted monikers will include the `machine_id` as the suffix.
