[![Pre-Commit](https://github.com/aidanmelen/terraform-aws-eks-auth/actions/workflows/pre-commit.yaml/badge.svg)](https://github.com/aidanmelen/terraform-aws-eks-auth/actions/workflows/pre-commit.yaml)
[![cookiecutter-tf-module](https://img.shields.io/badge/cookiecutter--tf--module-enabled-brightgreen)](https://github.com/aidanmelen/cookiecutter-tf-module)

# terraform-aws-eks-auth

A Terraform module to manage [cluster authentication](https://docs.aws.amazon.com/eks/latest/userguide/cluster-auth.html) (`aws-auth`) for an Elastic Kubernetes (EKS) cluster on AWS.

This modules works similar to the [aws_auth.tf](https://github.com/terraform-aws-modules/terraform-aws-eks/blob/v17.24.0/aws_auth.tf) file that was deprecated from the [terraform-eks-module](https://registry.terraform.io/modules/terraform-aws-modules/eks/aws/latest). The original approach for initializing the `aws-auth` ConfigMap used the `exec` resource to call `kubectl`. This solution can be problematic because it requires the host to have `kubectl` installed. This module implements a pure Terraform solution by using an Kubernetes Job to replace or patch the `aws-auth` ConfigMap

## Usage

### basic example

A basic example can be found at [examples/basic](examples/basic).

```hcl
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = ">= 18.0.0"

  cluster_name = var.name

  eks_managed_node_groups = {
    foo = {}
  }
}

module "eks_auth" {
  source = "aidanmelen/eks-auth/aws"
  eks    = module.eks
}
```

### replace example

In the replace example, the aws-auth configmap will be replaced with a new configmap managed with Terraform.

```hcl
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = ">= 18.0.0"

  cluster_name = var.name
  vpc_id       = module.vpc.vpc_id
  subnet_ids   = module.vpc.private_subnets

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

module "eks_auth" {
  source = "aidanmelen/eks-auth/aws"

  eks = module.eks

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
```

The full replace example can be found at [examples/replace](examples/replace).

## patch example

In the patch` xample, the aws-auth configmap will be patched with additional roles, users, and accounts.

```hcl
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = ">= 18.0.0"

  cluster_name = var.name
  vpc_id       = module.vpc.vpc_id
  subnet_ids   = module.vpc.private_subnets

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

module "eks_auth" {
  source = "aidanmelen/eks-auth/aws"

  eks         = module.eks
  init_action = "patch"

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
```

The full patch example can be found at [examples/patch](examples/patch).

## Makefile Targets

```text
Available targets:

help                           This help.
build                          Build docker image
install                        Install pre-commit
test                           Test with Terratest
test-basic                     Test Basic Example
test-complete                  Test Complete Example
tests                          Lint and Test
```

## License

MIT Licensed. See [LICENSE](https://github.com/aidanmelen/terraform-aws-eks-auth/tree/master/LICENSE) for full details.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.72 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 2.7.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 2.8.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [kubernetes_config_map_v1.aws_auth](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/config_map_v1) | resource |
| [kubernetes_job_v1.aws_auth_init](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/job_v1) | resource |
| [kubernetes_role_binding_v1.aws_auth_init](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/role_binding_v1) | resource |
| [kubernetes_role_v1.aws_auth_init](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/role_v1) | resource |
| [kubernetes_service_account_v1.aws_auth_init](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service_account_v1) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_eks"></a> [eks](#input\_eks) | The outputs from the `terraform-aws-eks` module. | `any` | n/a | yes |
| <a name="input_image_name"></a> [image\_name](#input\_image\_name) | Docker image name for the aws-auth-init job. The image must have the `kubectl` command line interface installed. | `string` | `"bitnami/kubectl"` | no |
| <a name="input_image_tag"></a> [image\_tag](#input\_image\_tag) | Docker image tag for the aws-auth-init job. Defaults to the EKS cluster `<major>.<minor>` version (i.e.: 1.21). | `string` | `""` | no |
| <a name="input_init_action"></a> [init\_action](#input\_init\_action) | Determines how the aws-auth configmap will be initialized.<br>  On `replace`, the aws-auth configmap will be replaced with a new configmap managed with Terraform.<br>  On `patch`, the aws-auth configmap will be patched in-place with additional roles, users, and accounts. | `string` | `"replace"` | no |
| <a name="input_k8s_additional_labels"></a> [k8s\_additional\_labels](#input\_k8s\_additional\_labels) | Additional kubernetes labels. | `map(string)` | `{}` | no |
| <a name="input_map_accounts"></a> [map\_accounts](#input\_map\_accounts) | Additional AWS account numbers to add to the aws-auth configmap. | `list(string)` | `[]` | no |
| <a name="input_map_roles"></a> [map\_roles](#input\_map\_roles) | Additional IAM roles to add to the aws-auth configmap. | <pre>list(object({<br>    rolearn  = string<br>    username = string<br>    groups   = list(string)<br>  }))</pre> | `[]` | no |
| <a name="input_map_users"></a> [map\_users](#input\_map\_users) | Additional IAM users to add to the aws-auth configmap. | <pre>list(object({<br>    userarn  = string<br>    username = string<br>    groups   = list(string)<br>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aws_auth_configmap_yaml"></a> [aws\_auth\_configmap\_yaml](#output\_aws\_auth\_configmap\_yaml) | Formatted yaml output for aws-auth configmap. |
| <a name="output_map_accounts"></a> [map\_accounts](#output\_map\_accounts) | The aws-auth map accounts. |
| <a name="output_map_roles"></a> [map\_roles](#output\_map\_roles) | The aws-auth map roles merged with the eks cluster node group and fargate profile roles. |
| <a name="output_map_users"></a> [map\_users](#output\_map\_users) | The aws-auth map users. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
