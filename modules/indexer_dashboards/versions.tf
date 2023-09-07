terraform{
  required_providers {
    datadog = {
      source  = "DataDog/datadog"
      version = "~> 3.4"
    }
  }

  required_version = "~> 1.3.2"
}