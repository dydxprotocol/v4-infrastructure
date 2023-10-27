variable "env" {
  default     = "dev"
  description = "dev/dev2/dev3/dev4/dev5/staging/testnet/public-testnet/testnet1/testnet2/mainnet"
}

variable "name" {
  default     = "datadog-agent"
  description = "name of the container"
}

variable "service_name" {
  type        = string
  description = "name of the service for DD_TAGS"
}

variable "environment_vars" {
  type        = map(string)
  default     = {}
  description = "environment variables"
}

variable "docker_labels" {
  type        = map(string)
  default     = {}
  description = "docker labels"
}

# https://docs.datadoghq.com/containers/amazon_ecs/apm/?tab=ecscontainermetadatafile#configure-your-application-container-to-submit-traces-to-datadog-agent
# Datadog recommends allocating 100 to the agent.
variable "container_cpu_units" {
  type        = number
  default     = 100
  description = "The number of cpu units to reserve for the container."
}

# https://docs.datadoghq.com/containers/amazon_ecs/apm/?tab=ecscontainermetadatafile#configure-your-application-container-to-submit-traces-to-datadog-agent
# Datadog recommends allocating 256MiB to the agent.
variable "container_memory_reservation" {
  type        = number
  default     = 256
  description = "The amount of memory (in MiB) to reserve for the container."
  nullable    = true
}

variable "datadog_api_key" {
  type        = string
  description = "Datadog API key"
  sensitive   = true
}

variable "docker_image_name" {
  type        = string
  default     = "public.ecr.aws/datadog/agent"
  description = "docker image name"
}

# Use a specific version here to control when an update to a new major version of the datadog agent is performed
# since major releases happen about once a year and contain breaking changes.
variable "docker_image_tag" {
  type        = string
  default     = "7"
  description = "docker image tag"
}

variable "dd_site" {
  type        = string
  default     = "datadoghq.com"
  nullable    = false
  description = "The site that the datadog agent will send data to"
}
