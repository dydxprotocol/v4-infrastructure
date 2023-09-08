# This data source allows referencing the effective Account ID, User ID,
# and ARN in which Terraform is authorized.
#
# See the following AWS provider documentation.
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

locals {
  account_id = data.aws_caller_identity.current.account_id
  region     = data.aws_region.current.name
}
