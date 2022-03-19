locals {
  name = "ex-${replace(basename(path.cwd), "_", "-")}"
}

################################################################################
# EKS Module
################################################################################

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = ">= 18.0.0"

  cluster_name    = local.name
  cluster_version = "1.21"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  self_managed_node_groups = {
    boo = {
      instance_type = "t3.medium"
      instance_market_options = {
        market_type = "spot"
      }
    }
  }

  eks_managed_node_groups = {
    foo = {}
  }

  fargate_profiles = {
    bar = {
      selectors = [
        {
          namespace = "bar"
        }
      ]
    }
  }
}

################################################################################
# EKS Auth Module
################################################################################

module "eks_auth" {
  source = "../../"
  eks    = module.eks

  should_patch_aws_auth_configmap = true

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
    {
      userarn  = "arn:aws:iam::66666666666:user/user2"
      username = "user2"
      groups   = ["system:masters"]
    },
  ]

  map_accounts = [
    "777777777777",
    "888888888888",
  ]
}
