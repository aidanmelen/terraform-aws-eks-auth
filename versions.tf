terraform {
  required_version = ">= 0.13.1"

  required_providers {
    http = {
      source  = "terraform-aws-modules/http"
      version = ">= 2.4.1"
    }

    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.13.1"
    }
  }
}
