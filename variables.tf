variable "eks_aws_auth_configmap_yaml" {
  description = "The `aws_auth_configmap_yaml` output from the `terraform-aws-eks` module."
  type        = string
  default     = "{}"
}

variable "kubectl_configmap_action" {
  description = <<EOT
  Determines how aws-auth configmap will be initialized.
  On `replace`, the aws-auth configmap will be replaced with a new configmap managed with Terraform.
  On `patch`, the aws-auth configmap will be patched with additional roles, users, and accounts.
  EOT
  type        = string
  default     = "replace"

  validation {
    condition = contains(
      ["replace", "patch"],
      var.kubectl_configmap_action
    )
    error_message = "Must be one either `replace` or `patch`."
  }
}

variable "aws_auth_additional_labels" {
  description = "Additional kubernetes labels applied on aws-auth ConfigMap"
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

variable "kubectl_image_url" {
  description = "Docker image name for the `kubectl` command line interface."
  type        = string
  default     = "bitnami/kubectl:latest"
}
