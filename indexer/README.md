# Indexer (WIP)

This directory defines Terraform configs for standing up an Indexer for V4.

## How to plan/apply the config

The database password for the RDS instance is set via a [sensitive](https://learn.hashicorp.com/tutorials/terraform/sensitive-variables)
variable, named `rds_db_password`.

To ensure that this sensitive value is not put into source control, it is not included in the
`terraform.tfvars` file used to set the values for the variables in the Terraform configs. Instead it should be set
in the Terraform Cloud workspace as a [sensitive variable](https://learn.hashicorp.com/tutorials/terraform/sensitive-variables#set-values-with-variables).

## Initial Stand-up Instructions

Please follow [this notion doc](https://www.notion.so/dydx/Indexer-Stand-up-Process-c707042919194403ac600380c5b5a3e7?pvs=4) for instructions for initial stand-up.

## Regulatory Strategy Integration
 
With the v4 software being decentralized, open source software, any users of such software are best positioned to evaluate integrations and settings from their respective operations and jurisdictions. dYdX Trading Inc. (“dYdX”) does not affiliate with or endorse a specific third-party risk management service.

Elliptic Ltd. (“Elliptic”), an unaffiliated and independent third party, has provided its API documentation [here](https://developers.elliptic.co/docs) and you can contact [dYdX-integration@elliptic.co](mailto:dYdX-integration@Elliptic.co) for more information about Elliptic's product offerings, and the technical compatibility of its services, given work it has done to provide coverage of this new blockchain software. To access such information, you will leave the dYdX GitHub repository and join a website made available by Elliptic — dYdX is not responsible for any action taken or content on the third-party website.

By default, to enable use of the `/screen` endpoint and continuous refreshing of the risk of each address ingested on the Indexer software, Indexer software deployments include Elliptic integration.

### Initial Setup:
#### Requirements:

- Elliptic API key

- Elliptic API secret

- Risk score threshold based on rules configured on the Elliptic account
  - Any address that returns a risk score above the threshold will be blocked by the Indexer, refer to Elliptic documentation on how to configure rules for determining the risk score

 #### Instructions:

1. In terraform, set the [indexer_compliance_client](https://github.com/dydxprotocol/v4-infrastructure/blob/317645051638e64e290c976a38176f90f2bb4a03/indexer/variables.tf#L366) variable to `ELLIPTIC` in your deployment. This is the default, so this step is optional unless the variable was set to another value.

2. In terraform, add the environment variable `ELLIPTIC_RISK_SCORE_THRESHOLD` to both the [comlink ECS env vars](https://github.com/dydxprotocol/v4-infrastructure/blob/317645051638e64e290c976a38176f90f2bb4a03/indexer/variables.tf#L395) and the [roundtable ECS env vars](https://github.com/dydxprotocol/v4-infrastructure/blob/317645051638e64e290c976a38176f90f2bb4a03/indexer/variables.tf#L413). This is the risk score threshold based on the rules configured on the Elliptic account. The default is 10.
    - You are solely responsible for determining this risk score threshold and rules in your Elliptic account based on your regulatory strategy, discussions with Elliptic and review of Elliptic documentation
    - E.g. 
 ```yaml
    [
       ... other config,
       {name = "ELLIPTIC_RISK_SCORE_THRESHOLD", value = "<configured threshold>"}
    ]
```

3. Before deploying the Indexer software, go to secrets manager and create the following 2 secrets in the same region where the Indexer will be running, you will need the environment variable that was passed into the Indexer software’s terraform config.

 - `{environment}-comlink-secrets`

	- The secret type should be Other type of secret

	- Key value pairs should be entered via plaintext:

		- `{"ELLIPTIC_API_KEY":"<your Elliptic API key>","ELLIPTIC_API_SECRET":"<your Elliptic API secret>"}`

	- Note that the name of the secret is entered in the step after setting the type / key-value pairs.

- `{environment}-roundtable-secrets`

	- Do the same as above.

4. Start the Indexer software services, and as blocks / activity on the network is ingested and the /screen endpoint on the Indexer software is called, you should see calls to Elliptic in your Elliptic account.

### Configuring the regulatory integration

#### Refreshing status of addresses

The Indexer services will attempt to refresh the status of each address stored in the Indexer using a regulatory vendor integration.

Several factors determine how often an address’s status is refreshed using a regulatory vendor integration.

-   addresses with trading or transfer activity within a 24 hour period are refreshed every 24 hours by default
-   addresses without any activity are refreshed every 30 days by default

To ensure that rate-limits aren’t reached on a regulatory vendor integration, the Indexer services have a maximum rate of refreshing address statuses. The default maximum rate is 100 addresses / 5 minutes or 4800 addresses / day.

All the numbers above can be configured using the [roundtable_ecs_environment_variables](<https://github.com/dydxprotocol/v4-infrastructure/blob/main/indexer/variables.tf#L413-L420>) var. The values that need to be set in the above variable are:

-   [ACTIVE_ADDRESS_THRESHOLD_SECONDS](<https://github.com/dydxprotocol/v4-chain/blob/main/indexer/services/roundtable/src/config.ts#L116>) : configures how far in the past the last transfer or trade for an address has to be for the address to be considered inactive, defaults to `86400` or 24 hours
-   [MAX_COMPLIANCE_DATA_AGE_SECONDS](<https://github.com/dydxprotocol/v4-chain/blob/main/indexer/services/roundtable/src/config.ts#L117C5-L117C5>): configures often inactive addresses are refreshed, defaults to `2630000` or 30 days
-   [MAX_ACTIVE_COMPLIANCE_DATA_AGE_SECONDS](<https://github.com/dydxprotocol/v4-chain/blob/main/indexer/services/roundtable/src/config.ts#L118>): configures how often active address are refreshed, defaults to `86400` or 24 hours
-   [MAX_COMPLIANCE_DATA_QUERY_PER_LOOP](<https://github.com/dydxprotocol/v4-chain/blob/main/indexer/services/roundtable/src/config.ts#L119>) : configures the maximum addresses to refresh every 5 minutes, defaults to `100` which is `4800` per day

An example configuration where active addresses are any that have trading activity in the past 7 days, where inactive addresses are refreshed every 14 days, where active addresses are refreshed every 3 days and where the maximum addresses refreshed per 5 minutes is 1000 (48,000 per day) would look like:

```yaml
[
  {name = "ACTIVE_ADDRESS_THRESHOLD_SECONDS", value = "604800"},
  {name = "MAX_COMPLIANCE_DATA_AGE_SECONDS", value = "1210000"},
  {name = "MAX_ACTIVE_COMPLIANCE_DATA_AGE_SECONDS", value = "259200"},
  {name = "MAX_COMPLIANCE_DATA_QUERY_PER_LOOP", value = "1000"}
]

```

#### Rate-limits

The Indexer services has rate limits for fetching the status of an address using a regulatory vendor integration, to allow deployers to prevent the Indexer from being used as a proxy for querying a regulatory vendor.

In addition, the Indexer is set up to cache the data returned from a regulatory vendor integration for a set period of time before fetching new data from the regulatory vendor integration for a given address.

The `/screen` endpoint allows querying for the restricted status of an address from a regulatory vendor.

The configuration for both rate-limits and caching are:

-   the `/screen` endpoint will return data that is cached if it is less than 24 hours old, otherwise a call is made to regulatory vendor to fetch new data (24 hours is the default)
    -   The rate-limit for cached data is the same as other GET endpoints, defaulting at 100 calls/10 seconds
-   there is a rate-limit of 2 calls/minute to regulatory vendor per IP (2/minute is the default)
-   there is a global rate-limit of 100 calls/minute to regulatory vendor for the Indexer deployment (100/minute is the default)

All the numbers above can be configured using the [comlink_ecs_environment_variables](<https://github.com/dydxprotocol/v4-infrastructure/blob/main/indexer/variables.tf#L395>) var.

The values that need to be set for the above variables are:

-   [MAX_AGE_SCREENED_ADDRESS_COMPLIANCE_DATA_SECONDS](<https://github.com/dydxprotocol/v4-chain/blob/main/indexer/services/comlink/src/config.ts#L55>) : configures the maximum stale-ness of cached regulatory vendor data that can be served without refreshing with a new call to regulatory vendor, defaults to `86400` or 24 hours
-   [RATE_LIMIT_SCREEN_QUERY_PROVIDER_POINTS](<https://github.com/dydxprotocol/v4-chain/blob/main/indexer/services/comlink/src/config.ts#L49>): configures the rate-limit per IP, this is the numerator in the rate / the number of requests, e.g. if the rate was 2 / minute then this variable is the `2`. By default this is set to `2`.
-   [RATE_LIMIT_SCREEN_QUERY_PROVIDER_DURATION_SECONDS](<https://github.com/dydxprotocol/v4-chain/blob/main/indexer/services/comlink/src/config.ts#L50>): configures the rate-limit per IP, this is the denominator in the rate / the time period, e.g. if the rate limit was 2 / minute then this variable is `60` (1 minute). By default this is set to `60` (1 minute).
-   [RATE_LIMIT_SCREEN_QUERY_PROVIDER_GLOBAL_POINTS](<https://github.com/dydxprotocol/v4-chain/blob/main/indexer/services/comlink/src/config.ts#L51C3-L51C49>): configures the per Indexer deployment rate-limit, this is the numerator in the rate / the number of requests, e.g. if the rate was 100 / minute then this variable is the `100`. By default this is set to `100`.
-   [RATE_LIMIT_SCREEN_QUERY_PROVIDER_GLOBAL_DURATION_SECONDS](<https://github.com/dydxprotocol/v4-chain/blob/main/indexer/services/comlink/src/config.ts#L53C3-L53C59>): configures the rate-limit per IP, this is the denominator in the rate / the time period, e.g. if the rate limit was 2 / minute then this variable is `60` (1 minute). By default this is set to `60` (1 minute).

An example configuration where cached data can be up to 3 days stale, with a rate limit of 5 per 2 minutes per IP and 300 per 5 minutes for the deployment would like:

```yaml
[
  {name = "MAX_AGE_SCREENED_ADDRESS_COMPLIANCE_DATA_SECONDS", value = "259200"},
  {name = "RATE_LIMIT_SCREEN_QUERY_PROVIDER_POINTS", value = "5"},
  {name = "RATE_LIMIT_SCREEN_QUERY_PROVIDER_DURATION_SECONDS", value = "120"},
  {name = "RATE_LIMIT_SCREEN_QUERY_PROVIDER_GLOBAL_POINTS", "value" = "300"},
  {name = "RATE_LIMIT_SCREEN_QUERY_PROVIDER_GLOBAL_DURATION_SECONDS", value = "300"},
]

```
