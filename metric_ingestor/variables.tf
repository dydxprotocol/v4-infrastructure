variable "datadog_api_key" {
  type        = string
  description = "Datadog API key"
  sensitive   = true
}

variable "datadog_app_key" {
  type        = string
  description = "Datadog App key"
  sensitive   = true
}

variable "datadog_site" {
  type        = string
  description = "Datadog API site to send data to"
  default     = null
}

variable "environment" {
  type        = string
  description = "Name of the environment {dev | dev2 | dev3 | dev4 | dev5 | staging | testnet | public-testnet | testnet1 | testnet2 | mainnet}."

  validation {
    condition = contains(
      ["dev", "dev2", "dev3", "dev4", "dev5", "staging", "testnet", "public-testnet", "testnet1", "testnet2", "mainnet"],
      var.environment
    )
    error_message = "Err: invalid environment. Must be one of {dev | dev2 | dev3 | dev4 | dev5 | staging | testnet | public-testnet | testnet1 | testnet2 | mainnet}."
  }
}

variable "region" {
  type        = string
  description = "AWS region to deploy the metric ingestor"
}

variable "validators" {
  type = list(object({
    name                 = string
    openmetrics_endpoint = string
  }))
  description = "List of external validators for which to collect and ingest metrics"
}

variable "ec2_instance_type" {
  type        = string
  description = "EC2 instance type for the metric ingestor instance"
}

variable "cidr_vpc" {
  type        = string
  description = "IPv4 CIDR block for the VPC."
}

variable "enabled" {
  type        = bool
  description = "Whether to enable the metric ingestor"
}
