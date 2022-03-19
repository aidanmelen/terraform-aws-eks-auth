variable "eks" {
  description = "The outputs from the `terraform-aws-eks` module."
  type        = any
}

variable "image_name" {
  description = "Docker image name for the aws-auth-init job. The image must have the `kubectl` command line interface installed."
  type        = string
  default     = "bitnami/kubectl"
}

variable "image_tag" {
  description = "Docker image tag for the aws-auth-init job. Defaults to the EKS cluster `<major>.<minor>` version (i.e.: 1.21)."
  type        = string
  default     = ""
}

variable "init_action" {
  description = <<EOT
  Determines how the aws-auth configmap will be initialized.
  On `replace`, the aws-auth configmap will be replaced with a new configmap managed with Terraform.
  On `patch`, the aws-auth configmap will be patched in-place with additional roles, users, and accounts.
  EOT
  type        = string
  default     = "replace"

  validation {
    condition = contains(
      ["replace", "patch"],
      var.init_action
    )
    error_message = "Must be one either `replace` or `patch`."
  }
}

variable "k8s_additional_labels" {
  description = "Additional kubernetes labels."
  default     = {}
  type        = map(string)
}

variable "map_accounts" {
  description = "Additional AWS account numbers to add to the aws-auth configmap."
  type        = list(string)
  default     = []
}

variable "map_roles" {
  description = "Additional IAM roles to add to the aws-auth configmap."
  type = list(object({
    rolearn  = string
    username = string
    groups   = list(string)
  }))
  default = []
}

variable "map_users" {
  description = "Additional IAM users to add to the aws-auth configmap."
  type = list(object({
    userarn  = string
    username = string
    groups   = list(string)
  }))
  default = []
}
