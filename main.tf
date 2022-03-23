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


resource "kubectl_manifest" "patch" {
  override_namespace = "kube-system"
  yaml_body          = local.aws_auth_configmap_yaml
}