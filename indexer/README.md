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
 
With the v4 software being decentralized, open source software, any users of such software are best positioned to evaluate their own risk management considerations for their respective operations and jurisdictions. dYdX Trading Inc. (“dYdX”) does not affiliate with or endorse a specific third-party risk management service. Elliptic Ltd. (“Elliptic”) is an unaffiliated third party independently providing information [here](https://developers.elliptic.co/docs) relevant to the technical compatibility of such services, given work it has done to provide coverage of this new blockchain software. To access such information, you will leave the dYdX GitHub repository and join a website made available by Elliptic — dYdX is not responsible for any action taken or content on the third-party website.

By default, to enable use of the `/screen` endpoint and continuous refreshing of the risk of each address ingested on the Indexer software, Indexer software deployments include Elliptic integration.

### Requirements:

- Elliptic API key

- Elliptic API secret

- Risk score threshold based on rules configured on the Elliptic account

 ### Instructions:

1. In terraform, set the [indexer_compliance_client](https://github.com/dydxprotocol/v4-infrastructure/blob/317645051638e64e290c976a38176f90f2bb4a03/indexer/variables.tf#L366) variable to `ELLIPTIC` in your deployment. This is the default, so this step is optional unless the variable was set to another value.

2. In terraform, add the environment variable `ELLIPTIC_RISK_SCORE_THRESHOLD` to both the [comlink ECS env vars](https://github.com/dydxprotocol/v4-infrastructure/blob/317645051638e64e290c976a38176f90f2bb4a03/indexer/variables.tf#L395) and the [roundtable ECS env vars](https://github.com/dydxprotocol/v4-infrastructure/blob/317645051638e64e290c976a38176f90f2bb4a03/indexer/variables.tf#L413). This is the risk score threshold based on the rules configured on the Elliptic account. The default is 10.

- E.g. `[{"ELLIPTIC_RISK_SCORE_THRESHOLD": <configured  threshold>}]`

3. Before deploying the Indexer software, go to secrets manager and create the following 2 secrets in the same region where the Indexer will be running, you will need the environment variable that was passed into the Indexer software’s terraform config.

 - `{environment}-comlink-secrets`

	- The secret type should be Other type of secret

	- Key value pairs should be entered via plaintext:

		- `{"ELLIPTIC_API_KEY":"<your Elliptic API key>","ELLIPTIC_API_SECRET":"<your Elliptic API secret>"}`

	- Note that the name of the secret is entered in the step after setting the type / key-value pairs.

- `{environment}-roundtable-secrets`

	- Do the same as above.

4. Start the Indexer software services, and as blocks / activity on the network is ingested and the /screen endpoint on the Indexer software is called, you should see calls to Elliptic in your Elliptic account.
