module "eks" {
  source = "terraform-aws-modules/eks/aws"
  # ...
}

module "eks_auth" {
  source = "aidanmelen/eks-auth/aws"
  eks    = module.eks
  patch  = true
}