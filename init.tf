resource "kubernetes_service_account_v1" "aws_auth" {
  metadata {
    name      = "aws-auth-init"
    namespace = "kube-system"
  }
}

resource "kubernetes_role_v1" "aws_auth" {
  metadata {
    name      = "terraform:aws-auth-init"
    namespace = "kube-system"
  }

  rule {
    api_groups     = [""]
    resources      = ["configmaps"]
    resource_names = ["aws-auth"]
    verbs          = ["delete"]
  }
}

resource "kubernetes_role_binding_v1" "aws_auth" {
  metadata {
    name      = kubernetes_service_account_v1.aws_auth.metadata.0.name
    namespace = "kube-system"
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
  }

  spec {
    template {
      metadata {}
      spec {
        service_account_name = kubernetes_service_account_v1.aws_auth.metadata.0.name
        container {
          name  = "aws-auth-init"
          image = "bitnami/kubectl:latest"

          # Delete the `aws-auth` configmap that was created by AWS EKS.
          # This `aws-auth` data will be merged with a new aws-auth configmap managed by this module.
          command = ["/bin/sh", "-c", "kubectl delete configmap aws-auth --namespace kube-system"]
        }
        restart_policy = "Never"
      }
    }
  }

  wait_for_completion = true

  timeouts {
    create = "5m"
  }
}
