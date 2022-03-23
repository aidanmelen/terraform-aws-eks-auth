module "eks" {
  source = "./mock_eks"
}


module "eks_auth" {
  source    = "../../"
  eks       = module.eks
  image_tag = "1.22"
  patch     = true
}
