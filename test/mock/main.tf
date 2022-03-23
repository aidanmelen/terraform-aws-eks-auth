module "eks" {
  source = "./mock_eks"
}


module "eks_auth" {
  source    = "../../"
  eks       = module.eks

  map_roles = [
    {
      rolearn  = "arn:aws:iam::66666666666:role/role1"
      username = "role1"
      groups   = ["system:masters"]
    },
  ]

  map_users = [
    {
      userarn  = "arn:aws:iam::66666666666:user/user1"
      username = "user1"
      groups   = ["system:masters"]
    },
    # {
    #   userarn  = "arn:aws:iam::66666666666:user/user2"
    #   username = "user2"
    #   groups   = ["system:masters"]
    # },
  ]

  # map_accounts = [
  #   "777777777777",
  #   "888888888888",
  # ]
}
