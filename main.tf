locals {
  merged_map_roles = yamlencode(
    distinct(concat(
      try(yamldecode(yamldecode(var.eks_aws_auth_configmap_yaml).data.mapRoles), []),
      var.map_roles,
    ))
  )
}

resource "kubernetes_config_map_v1" "aws_auth" {
  depends_on = [kubernetes_job_v1.aws_auth]

  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
    labels = merge(
      {
        "app.kubernetes.io/managed-by" = "Terraform"
        # / are replaced by . because label validator fails in this lib
        # https://github.com/kubernetes/apimachinery/blob/1bdd76d09076d4dc0362456e59c8f551f5f24a72/pkg/util/validation/validation.go#L166
        "terraform.io/module" = "terraform-aws-modules.eks.aws"
      },
      var.aws_auth_additional_labels
    )
  }

  data = {
    mapRoles    = yamlencode(local.merged_map_roles)
    mapUsers    = yamlencode(var.map_users)
    mapAccounts = yamlencode(var.map_accounts)
  }
}
