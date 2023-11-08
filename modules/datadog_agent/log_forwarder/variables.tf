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


variable "name" {
  type        = string
  description = "Name of the app."
}

variable "datadog_api_key" {
  type        = string
  description = "Datadog API key"
  sensitive   = true
}

variable "log_group_name" {
  type        = string
  description = "Name of the log group."
}

variable "filter_pattern" {
  type        = string
  description = "Pattern to filter the logs on. For example, '{ $.level = error }'"
}

variable "dd_site" {
  type        = string
  default     = "datadoghq.com"
  description = "The site that the datadog agent will send data to"
}

variable "disable_subscription" {
  type        = bool
  description = "Disable datadog log forwarder or not. Default: false"
  default     = false
}
