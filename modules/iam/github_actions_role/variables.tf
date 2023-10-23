variable "name" {
  type        = string
  description = "Name to use as the prefix for the IAM roles."
}

variable "environment" {
  type        = string
  description = "Name of the environment {dev | dev2 | dev3 | dev4 | dev5 | staging | testnet | public-testnet | research | testnet1 | testnet2 | mainnet}."

  validation {
    condition = contains(
      ["dev", "dev2", "dev3", "dev4", "dev5", "staging", "testnet", "public-testnet", "research", "testnet1", "testnet2", "mainnet"],
      var.environment
    )
    error_message = "Err: invalid environment. Must be one of {dev | dev2 | dev3 | dev4 | dev5 | staging | testnet | public-testnet | research | testnet1 | testnet2 | mainnet}."
  }
}

variable "ecr_repository_arns" {
  type        = list(string)
  description = "List of the ARNs of ECR respositories the created iam roles should have push-pull access to."
}

variable "lambda_arns" {
  type        = list(string)
  description = "List of the ARNs of Lambdas the created iam roles should have permissions to deploy."
}

variable "s3_bucket_arns" {
  type        = list(string)
  description = "List of the ARNs of S3 buckets the created iam roles should have permissions to upload to."
  default     = []
}

variable "assume_iam_roles" {
  type        = list(string)
  description = "List of the ARNs of IAM roles the created iam roles should have permissions to assume."
}
