terraform {
  required_version = ">= 0.13.1"

  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.13.1"
    }
  }
}
