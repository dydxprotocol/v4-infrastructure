terraform {
  cloud {
    organization = "dydxprotocol"

    workspaces {
      tags = ["indexers"]
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "= 4.67.0"
    }

    datadog = {
      source  = "DataDog/datadog"
      version = "~> 3.4"
    }
  }

  required_version = "~> 1.3.2"
}
