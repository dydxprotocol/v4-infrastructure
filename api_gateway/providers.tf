terraform {
  cloud {
    organization = "dydxprotocol"

    workspaces {
      name = ["amplitude-api-gateway"]
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }

  required_version = "~> 1.3.2"
}

provider "aws" {
  # Expects the following environment variables:
  # - AWS_ACCESS_KEY_ID
  # - AWS_SECRET_ACCESS_KEY
  region = var.region
}
