# dYdX v4 - Terraform

This repository contains Terraform related configs for `v4` chain used for testing purposes.

## Terraform Cloud

We use [Terraform Cloud](https://cloud.hashicorp.com/products/terraform) to deploy and manage infrastructure resources. Terraform Cloud helps with Terraform state management as well as automating the deployment pipeline (i.e. deploying infra changes made in this Github repo).

Install the terraform cli using tfenv. We currently use version 1.3.2 of terraform.

> Terraform Cloud account for dYdX v4: [link](https://app.terraform.io/app/dydxprotocol/workspaces)

### How to test local infra changes against "dev" env

This workspace is configured using [The CLI-driven Run Workflow](https://www.terraform.io/cloud-docs/run/cli). You should feel empowered to plan and apply at your discretion to this workspace with no approval or code review required. This is to help facilitate your own testing before opening a PR to `v4-terraform`. In order to plan and apply in this workspace, follow these steps:

1. Install `terraform` if you haven't done so already following the instructions [here](https://www.terraform.io/downloads).
    1. Running `terraform --version` should output a version `>= v1.3.2`.
1. Login to Terraform Cloud via `terraform login`. You will be asked to create a token and provide it to the CLI.
1. `cd` into the relevant folder, for example `/validators`, `/indexer`, `/faucet`, or `/loadtesters`.
1. Initialize terraform if you haven't done so already with `terraform init`.
1. Run `terraform workspace select validators-dev` to select the dev workspace for `validators`. You can also run `terraform workspace list` to see available workspaces.
1. Once you've selected the `validators-dev` workspace, feel free to run `terraform plan` and `terraform apply` to trigger your runs. Note that these runs will still take place remotely in Terraform Cloud, but the output will be streamed to your machine.

### How to apply changes to infra to "staging" env

1. Go to the corresponding Terraform Cloud workspace (i.e. https://app.terraform.io/app/dydxprotocol/workspaces/validators-staging)

2. Go to `Runs` tab

3. Identify or Trigger `Run`:

* If you recently merged a PR to the `main` branch, then you would see a `Run` already triggered. Use the triggered `Run` in this case.
* Otherwise, trigger a new `Run` by selecting `Actions > Start new run`. Use the newly triggered `Run` in this case.

> Note: in some cases, if previous runs have not been applied, you will see a list of runs that are queued. In this case, one way to resolve this is to cancel all previous runs and then triggering a new fresh run via UI.

4. Review the `plan` output. Ensure that the resources being created, updated or destroyed are intended.

5. Confirm & Apply via UI.

## Datadog
For datadog-specific instructions, follow the instructions [here](https://github.com/dydxprotocol/v4-infrastructure/tree/main/modules/datadog_agent/README.md)
