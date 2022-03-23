resource "kubernetes_service_account_v1" "aws_auth" {
  metadata {
    name      = "terraform-eks-auth-aws"
    namespace = "kube-system"
    labels    = local.k8s_labels
  }
}

resource "kubernetes_role_v1" "aws_auth" {
  metadata {
    name      = "terraform-eks-auth-aws"
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
      "delete", # is used when replacing the pre-existing configmap with another managed with terraform
    ]
  }
}

resource "kubernetes_role_binding_v1" "aws_auth" {
  metadata {
    name      = kubernetes_service_account_v1.aws_auth.metadata[0].name
    namespace = "kube-system"
    labels    = local.k8s_labels
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = kubernetes_role_v1.aws_auth.metadata[0].name
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account_v1.aws_auth.metadata[0].name
    namespace = "kube-system"
  }
}
