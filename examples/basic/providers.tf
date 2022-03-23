provider "aws" {
  region = var.aws_region
  default_tags {
    tags = {
      Example    = local.name
      GithubRepo = "terraform-aws-eks-auth"
      GithubOrg  = "aidan-melen"
    }
  }
}

provider "kubernetes" {
  alias                  = "sandbox_kubernetes"
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}
