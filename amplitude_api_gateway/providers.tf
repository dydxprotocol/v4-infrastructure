terraform {
  cloud {
    organization = "dydxopsdao"

    workspaces {
      name = ["amplitude-api-gateway"]
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.32"
    }
  }

  required_version = "~> 1.5"
}

provider "aws" {
  # Expects the following environment variables:
  # - AWS_ACCESS_KEY_ID
  # - AWS_SECRET_ACCESS_KEY
  region = var.region
}
