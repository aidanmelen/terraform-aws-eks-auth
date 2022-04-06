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
  ca_certificate = base64decode(
    coalesce(
      var.cluster_ca_certificate,
      var.eks.cluster_certificate_authority_data
    )
  )
  timeout        = var.wait_for_cluster_timeout
}

resource "kubectl_manifest" "aws_auth" {
  depends_on = [data.http.wait_for_cluster]

  # A conflict will occur when map_roles are added before a node group or fargate profile is joined with the cluster
  # This resource does not yet support `--force-conflicts` so replacing the `aws-auth` configmap when change occur prevents a conflict
  # https://github.com/gavinbunney/terraform-provider-kubectl/issues/139#issuecomment-1077049925
  force_new = true

  override_namespace = "kube-system"
  yaml_body          = local.aws_auth_configmap_yaml
}
