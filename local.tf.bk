locals {
  does_aws_auth_configmap_exist = data.kubernetes_config_map_v1.aws_auth.id != null

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

  aws_auth_image = join(":", [
    var.image_name,
    var.image_tag == null ? data.aws_eks_cluster.cluster[0].version : var.image_tag
  ])

  k8s_labels = merge(
    {
      "app.kubernetes.io/managed-by" = "Terraform"
      # / are replaced by . because label validator fails in this lib
      # https://github.com/kubernetes/apimachinery/blob/1bdd76d09076d4dc0362456e59c8f551f5f24a72/pkg/util/validation/validation.go#L166
      "terraform.io/module" = "aidanmelen.eks-auth.aws"
    },
    var.k8s_additional_labels
  )
}
