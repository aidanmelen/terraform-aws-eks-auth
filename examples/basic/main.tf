locals {
  name = "ex-${replace(basename(path.cwd), "_", "-")}"
}

################################################################################
# EKS Module
################################################################################

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = ">= 18.0.0"

  cluster_name = local.name
  vpc_id       = module.vpc.vpc_id
  subnet_ids   = module.vpc.private_subnets

  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true

  eks_managed_node_groups = {
    foo = {}
  }
}

################################################################################
# AWS AUTH Module
################################################################################

module "eks_auth" {
  source = "../../"

  eks_aws_auth_configmap_yaml = module.eks.aws_auth_configmap_yaml
}
