locals {


  merged_map_roles = distinct(concat(
    try(yamldecode(yamldecode(var.eks.aws_auth_configmap_yaml).data.mapRoles), []),
    var.map_roles,
  ))

  aws_auth_configmap_yaml = templatefile("${path.module}/templates/aws_auth_cm.tpl",
    {
      map_roles    = local.merged_map_roles
      map_users    = var.map_users
      map_accounts = var.map_accounts
    }
  )
}

data "http" "wait_for_cluster" {
  url            = format("%s/healthz", var.eks.cluster_endpoint)
  ca_certificate = base64decode(var.eks.cluster_certificate_authority_data)
  timeout        = var.wait_for_cluster_timeout
}

resource "kubernetes_config_map_v1" "aws_auth" {

  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = {
    "mapRoles"    = yamlencode(local.merged_map_roles)
    "mapUsers"    = yamlencode(var.map_users)
    "mapAccounts" = yamlencode(var.map_accounts)
  }
}


resource "kubernetes_config_map_v1_data" "aws_auth" {


  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = {
    "mapRoles"    = yamlencode(local.merged_map_roles)
    "mapUsers"    = yamlencode(var.map_users)
    "mapAccounts" = yamlencode(var.map_accounts)
  }

  force = true
}
