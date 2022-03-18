resource "kubernetes_service_account_v1" "aws_auth" {
  metadata {
    name      = "aws-auth-init"
    namespace = "kube-system"
    labels    = local.k8s_labels
  }
}

resource "kubernetes_role_v1" "aws_auth" {
  metadata {
    name      = "terraform:aws-auth-init"
    namespace = "kube-system"
    labels    = local.k8s_labels
  }

  rule {
    api_groups     = [""]
    resources      = ["configmaps"]
    resource_names = ["aws-auth"]
    verbs          = [
      "patch",
      "delete", # then replace with configmap managed with terraform 
    ]
  }
}

resource "kubernetes_role_binding_v1" "aws_auth" {
  metadata {
    name      = kubernetes_service_account_v1.aws_auth.metadata.0.name
    namespace = "kube-system"
    labels    = local.k8s_labels
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = kubernetes_role_v1.aws_auth.metadata.0.name
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account_v1.aws_auth.metadata.0.name
    namespace = "kube-system"
  }
}

resource "kubernetes_job_v1" "aws_auth" {
  metadata {
    name      = "aws-auth-init"
    namespace = "kube-system"
    labels    = local.k8s_labels
  }

  spec {
    template {
      metadata {}
      spec {
        service_account_name = kubernetes_service_account_v1.aws_auth.metadata.0.name
        container {
          name    = "aws-auth-init"
          image   = "bitnami/kubectl:latest"
          command = ["/bin/sh", "-c", local.kubectl_cmd]
        }
        restart_policy = "OnFailure"
      }
    }
  }

  wait_for_completion = true

  timeouts {
    create = "20m"
  }
}
