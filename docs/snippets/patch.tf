module "eks" {
  source = "terraform-aws-modules/eks/aws"
  # insert the 15 required variables here
}

module "eks_auth" {
  source = "aidanmelen/eks-auth/aws"
  eks    = module.eks
  patch  = true
}