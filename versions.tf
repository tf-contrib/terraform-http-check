# The http provider is the caller's.
terraform {
  required_version = ">= 1.9.0"

  required_providers {
    http = {
      source  = "hashicorp/http"
      version = "~> 3.5"
    }
  }
}
