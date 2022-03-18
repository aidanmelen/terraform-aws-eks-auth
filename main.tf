locals {
  merged_map_roles = distinct(concat(
    try(yamldecode(yamldecode(var.eks_aws_auth_configmap_yaml).data.mapRoles), []),
    var.map_roles,
  ))

  aws_auth_configmap_yaml = templatefile("${path.module}/templates/aws_auth_cm.tpl",
    {
      map_roles    = local.merged_map_roles
      map_users    = var.map_users
      map_accounts = var.map_accounts
    }
  )

  kubectl_cmd = (
    var.kubectl_configmap_action == "patch" ?
    "kubectl patch configmap/aws-auth --patch \"${local.aws_auth_configmap_yaml}\" -n kube-system" :
    "kubectl delete configmap/aws-auth -n kube-system"
  )

  k8s_labels = merge(
    {
      "app.kubernetes.io/managed-by" = "Terraform"
      # / are replaced by . because label validator fails in this lib
      # https://github.com/kubernetes/apimachinery/blob/1bdd76d09076d4dc0362456e59c8f551f5f24a72/pkg/util/validation/validation.go#L166
      "terraform.io/module" = "terraform-aws-modules.eks-auth.aws"
    },
    var.aws_auth_additional_labels
  )
}

resource "kubernetes_config_map_v1" "aws_auth" {
  count = var.kubectl_configmap_action == "replace" ? 1 : 0

  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
    labels    = local.k8s_labels
  }

  data = {
    mapRoles    = yamlencode(local.merged_map_roles)
    mapUsers    = yamlencode(var.map_users)
    mapAccounts = yamlencode(var.map_accounts)
  }

  depends_on = [kubernetes_job_v1.aws_auth]
}
