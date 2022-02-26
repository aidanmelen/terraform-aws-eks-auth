[![Lint Status](https://github.com/aidanmelen/terraform-aws-eks-auth/workflows/Lint/badge.svg)](https://github.com/aidanmelen/terraform-aws-eks-auth/actions)
[![Security Status](https://github.com/aidanmelen/terraform-aws-eks-auth/workflows/Security/badge.svg)](https://github.com/aidanmelen/terraform-aws-eks-auth/actions)
[![pre-commit](https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit&logoColor=white)](https://github.com/pre-commit/pre-commit)
[![cookiecutter-tf-module](https://img.shields.io/badge/cookiecutter--tf--module-enabled-brightgreen)](https://github.com/aidanmelen/cookiecutter-tf-module)
[![tflint](https://img.shields.io/badge/code--style-tflint-black)](https://github.com/terraform-linters/tflint)

# terraform-aws-eks-auth

A Terraform module to manage [cluster authentication](https://docs.aws.amazon.com/eks/latest/userguide/cluster-auth.html) (`aws-auth`) for an Elastic Kubernetes (EKS) cluster on AWS.

## Assumptions

- You want to manage your AWS EKS cluster with the [terraform-aws-eks](https://github.com/terraform-aws-modules/terraform-aws-eks) module.
- You want to manage the `aws-auth` configmap with Terraform.

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

module "aws_auth" {
  source = "../../"

  eks_aws_auth_configmap_yaml = module.eks.aws_auth_configmap_yaml
}
```

### complete example

A complete example can be found at [examples/complete](examples/complete).

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
    bar = {}
  }
}

module "aws_auth" {
  source = "../../"

  eks_aws_auth_configmap_yaml = module.eks.aws_auth_configmap_yaml

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

## Makefile Targets

```text
Available targets:

help                           This help.
build                          Build docker image
install                        Install pre-commit
test                           Test with Terratest
test-basic                     Test Basic Example
test-complete                  Test Basic Example
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
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 1.11.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 2.8.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [kubernetes_config_map.aws_auth](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/config_map) | resource |
| [kubernetes_job_v1.aws_auth](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/job_v1) | resource |
| [kubernetes_role_binding_v1.aws_auth](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/role_binding_v1) | resource |
| [kubernetes_role_v1.aws_auth](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/role_v1) | resource |
| [kubernetes_service_account_v1.aws_auth](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service_account_v1) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_auth_additional_labels"></a> [aws\_auth\_additional\_labels](#input\_aws\_auth\_additional\_labels) | Additional kubernetes labels applied on aws-auth ConfigMap | `map(string)` | `{}` | no |
| <a name="input_eks_aws_auth_configmap_yaml"></a> [eks\_aws\_auth\_configmap\_yaml](#input\_eks\_aws\_auth\_configmap\_yaml) | The `aws_auth_configmap_yaml` output from the `terraform-aws-eks` module. | `string` | `"  apiVersion: v1\n  kind: ConfigMap\n  metadata:\n    name: aws-auth\n    namespace: kube-system\n  data:\n    mapRoles: |\n      -\n"` | no |
| <a name="input_map_accounts"></a> [map\_accounts](#input\_map\_accounts) | Additional AWS account numbers to add to the aws-auth configmap. | `list(string)` | `[]` | no |
| <a name="input_map_roles"></a> [map\_roles](#input\_map\_roles) | Additional IAM roles to add to the aws-auth configmap. | <pre>list(object({<br>    rolearn  = string<br>    username = string<br>    groups   = list(string)<br>  }))</pre> | `[]` | no |
| <a name="input_map_users"></a> [map\_users](#input\_map\_users) | Additional IAM users to add to the aws-auth configmap. | <pre>list(object({<br>    userarn  = string<br>    username = string<br>    groups   = list(string)<br>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_config_map"></a> [config\_map](#output\_config\_map) | The `aws-auth` config map. |
| <a name="output_config_map_yaml"></a> [config\_map\_yaml](#output\_config\_map\_yaml) | The `aws-auth` config map YAML. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
