data "aws_eks_cluster" "cluster" {
  count = var.image_tag == null ? 1 : 0
  name  = var.eks.cluster_id
}

data "kubernetes_config_map_v1" "aws_auth" {
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }
}
