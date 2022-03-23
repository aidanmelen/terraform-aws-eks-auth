data "aws_eks_cluster" "cluster" {
  count = var.image_tag == null ? 1 : 0
  name  = var.eks.cluster_id
}

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

resource "kubernetes_job_v1" "aws_auth" {
  count = var.patch == false ? 1 : 0

  metadata {
    name      = "terraform-eks-auth-aws"
    namespace = "kube-system"
    labels    = local.k8s_labels
  }

  spec {
    template {
      metadata {}
      spec {
        service_account_name = kubernetes_service_account_v1.aws_auth.metadata[0].name
        container {
          name    = "terraform-eks-auth-aws"
          image   = local.aws_auth_image
          command = ["/bin/sh", "-c", "kubectl delete configmap/aws-auth -n kube-system"]
        }
        restart_policy = "Never"
      }
    }
  }

  wait_for_completion = true

  timeouts {
    create = "10m"
    update = "10m"
  }

  # Ensure the aws-auth configmap is only deleted and replaced on the first run
  lifecycle {
    ignore_changes = [
      metadata,
      spec,
    ]
  }
}

resource "kubernetes_config_map_v1" "aws_auth" {
  count = var.patch == false ? 1 : 0

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

provider "kubernetes" {
  alias                  = "terraform_service_account"
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(data.kubernetes_secret_v1.aws_auth.data["ca.crt"])
  token                  = data.kubernetes_secret_v1.aws_auth.data.token
}
