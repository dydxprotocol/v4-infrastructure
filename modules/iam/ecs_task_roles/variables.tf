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

variable "additional_task_role_policies" {
  type = list(object({
    name  = string
    value = string
  }))
  description = "List of additional policy ARNs to attach to the ECS task role."
  default     = []
}
