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
  default     = null
}

variable "should_patch_aws_auth_configmap" {
  description = "Determines whether to patch the aws-auth configmap in-place with additional roles, users, and accounts. Replace the aws-auth configmap by default."
  type        = bool
  default     = false
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
