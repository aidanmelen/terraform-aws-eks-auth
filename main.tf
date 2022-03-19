################################################################################
# Locals
################################################################################

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

  aws_auth_init_image = join(":", [
    var.image_name,
    var.image_tag != "" ? var.image_tag : try(var.eks.cluster_version, "latest")
  ])

  aws_auth_init_cmd = (
    var.init_action == "patch" ?
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
    var.k8s_additional_labels
  )
}

################################################################################
# Kubernetes RBAC
################################################################################

resource "kubernetes_service_account_v1" "aws_auth_init" {
  metadata {
    name      = "aws-auth-init"
    namespace = "kube-system"
    labels    = local.k8s_labels
  }
}

resource "kubernetes_role_v1" "aws_auth_init" {
  metadata {
    name      = "terraform:aws-auth-init"
    namespace = "kube-system"
    labels    = local.k8s_labels
  }

  rule {
    api_groups     = [""]
    resources      = ["configmaps"]
    resource_names = ["aws-auth"]
    verbs = [
      "get",
      "patch",
      "delete", # is used when replacing with pre-existing configmap with another managed with terraform
    ]
  }
}

resource "kubernetes_role_binding_v1" "aws_auth_init" {
  metadata {
    name      = kubernetes_service_account_v1.aws_auth_init.metadata.0.name
    namespace = "kube-system"
    labels    = local.k8s_labels
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = kubernetes_role_v1.aws_auth_init.metadata.0.name
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account_v1.aws_auth_init.metadata.0.name
    namespace = "kube-system"
  }
}

################################################################################
# Kubernetes Job
################################################################################

resource "kubernetes_job_v1" "aws_auth_init" {
  metadata {
    name      = "aws-auth-init"
    namespace = "kube-system"
    labels    = local.k8s_labels
  }

  spec {
    template {
      metadata {}
      spec {
        service_account_name = kubernetes_service_account_v1.aws_auth_init.metadata.0.name
        container {
          name    = "aws-auth-init"
          image   = local.aws_auth_init_image
          command = ["/bin/sh", "-c", local.aws_auth_init_cmd]
        }
        restart_policy = "Never"
      }
    }
  }

  wait_for_completion = true

  timeouts {
    create = "15m"
    update = "15m"
  }
}

################################################################################
# Kubernetes ConfigMap
################################################################################

resource "kubernetes_config_map_v1" "aws_auth" {
  count = var.init_action == "replace" ? 1 : 0

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

  depends_on = [kubernetes_job_v1.aws_auth_init]
}
