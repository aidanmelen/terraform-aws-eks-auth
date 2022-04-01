terraform {
  required_version = ">= 0.13.1"

  required_providers {
    http = {
      source  = "terraform-aws-modules/http"
      version = ">= 2.4.1"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.10.0"
    }
  }
}
