# Note: TF does not support dynamically defined providers (i.e. "for_each").
# Therefore, we need to statically define the providers.

# Datadog provider. 
provider "datadog" {
  api_key = var.datadog_api_key
  app_key = var.datadog_app_key
}

# Default AWS provider.
provider "aws" {
  region = var.region
}
