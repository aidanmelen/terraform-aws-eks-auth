locals {
  name = "ex-${replace(basename(path.cwd), "_", "-")}"
}

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