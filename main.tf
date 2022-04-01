locals {
  merged_map_roles = distinct(concat(
    try(yamldecode(yamldecode(var.eks.aws_auth_configmap_yaml).data.mapRoles), []),
    var.map_roles,
  ))
}

data "http" "wait_for_cluster" {
  url            = format("%s/healthz", var.eks.cluster_endpoint)
  ca_certificate = base64decode(var.eks.cluster_certificate_authority_data)
  timeout        = var.wait_for_cluster_timeout
}

resource "kubernetes_config_map_v1_data" "aws_auth" {
  depends_on = [data.http.wait_for_cluster]

  metadata {
    name      = "aws-auth"
    namespace = "kubesystem"
  }

  data = {
    "mapRoles"    = local.merged_map_roles
    "mapUsers"    = var.map_users
    "mapAccounts" = var.map_accounts
  }

  force = true
}
