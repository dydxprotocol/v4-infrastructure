# Default provider.
provider "aws" {
  region = "ap-northeast-1"
}

# AWS region providers.
provider "aws" {
  alias  = "ap_northeast_1"
  region = "ap-northeast-1"
}

provider "aws" {
  alias  = "us-east-2"
  region = "us-east-2"
}

# Datadog
provider "datadog" {
  api_key = var.datadog_api_key
  app_key = var.datadog_app_key
  api_url = var.datadog_api_url
}
