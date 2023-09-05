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
