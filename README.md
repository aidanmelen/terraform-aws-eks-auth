[![Pre-Commit](https://github.com/aidanmelen/terraform-aws-eks-auth/actions/workflows/pre-commit.yaml/badge.svg)](https://github.com/aidanmelen/terraform-aws-eks-auth/actions/workflows/pre-commit.yaml)
[![cookiecutter-tf-module](https://img.shields.io/badge/cookiecutter--tf--module-enabled-brightgreen)](https://github.com/aidanmelen/cookiecutter-tf-module)
[![StandWithUkraine](https://raw.githubusercontent.com/vshymanskyy/StandWithUkraine/main/badges/StandWithUkraine.svg)](https://github.com/vshymanskyy/StandWithUkraine/blob/main/docs/README.md)

# terraform-aws-eks-auth

A Terraform module to manage [cluster authentication](https://docs.aws.amazon.com/eks/latest/userguide/cluster-auth.html) (`aws-auth`) for an Elastic Kubernetes (EKS) cluster on AWS.

This modules works similar to the [aws_auth.tf](https://github.com/terraform-aws-modules/terraform-aws-eks/blob/v17.24.0/aws_auth.tf) file that was deprecated from the [terraform-eks-module](https://registry.terraform.io/modules/terraform-aws-modules/eks/aws/latest). Instead of running `kubectl` with `exec` resource, the `aws-auth` configmap is managed with `kubectl` running in a kuberetes job. As a result, this terraform can run without `kubectl` being installed on the host. 

⚠️ Similiar to the EKS cluster add-ons, the kubernetes job will not run until at least one compute node is joined to the cluster.

## Usage

The `aws-auth` configmap will be replaced with a new configmap merged with the additional roles, users, and accounts. Please see [examples/complete](examples/complete) for more information.

```hcl
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  ...
}

module "eks_auth" {
  source = "aidanmelen/eks-auth/aws"
  eks    = module.eks

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

## Patch ConfigMap

The `aws-auth` configmap will be patched in-place with additional roles, users, and accounts. Please see [examples/patch](examples/patch) for more information.


```hcl
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  ...
}

module "eks_auth" {
  source = "aidanmelen/eks-auth/aws"
  eks    = module.eks
  patch  = true

  map_roles = [
    {
      rolearn  = "arn:aws:iam::66666666666:role/role1"
      username = "role1"
      groups   = ["system:masters"]
    },
  ]
}
```

## Makefile Targets

```text
help                 This help.
build                Build docker image
dev                  Run docker dev container
install              Install project
lint                 Lint with pre-commit
tests                Test with Terratest
test-basic           Test Basic Example
test-complete         Test Complete Example
test-patch           Test Patch Example
clean                Clean project
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
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 3.72 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | >= 2.7.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [kubernetes_config_map_v1.aws_auth](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/config_map_v1) | resource |
| [kubernetes_job_v1.aws_auth_init_patch](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/job_v1) | resource |
| [kubernetes_job_v1.aws_auth_init_replace](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/job_v1) | resource |
| [kubernetes_role_binding_v1.aws_auth_init](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/role_binding_v1) | resource |
| [kubernetes_role_v1.aws_auth_init](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/role_v1) | resource |
| [kubernetes_service_account_v1.aws_auth_init](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service_account_v1) | resource |
| [aws_eks_cluster.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_eks"></a> [eks](#input\_eks) | The outputs from the `terraform-aws-eks` module. | `any` | n/a | yes |
| <a name="input_image_name"></a> [image\_name](#input\_image\_name) | Docker image name for the aws-auth-init job. The image must have the `kubectl` command line interface installed. | `string` | `"bitnami/kubectl"` | no |
| <a name="input_image_tag"></a> [image\_tag](#input\_image\_tag) | Docker image tag for the aws-auth-init job. Defaults to the EKS cluster `<major>.<minor>` version (i.e.: 1.21). | `string` | `null` | no |
| <a name="input_k8s_additional_labels"></a> [k8s\_additional\_labels](#input\_k8s\_additional\_labels) | Additional kubernetes labels. | `map(string)` | `{}` | no |
| <a name="input_map_accounts"></a> [map\_accounts](#input\_map\_accounts) | Additional AWS account numbers to add to the aws-auth configmap. | `list(string)` | `[]` | no |
| <a name="input_map_roles"></a> [map\_roles](#input\_map\_roles) | Additional IAM roles to add to the aws-auth configmap. | <pre>list(object({<br>    rolearn  = string<br>    username = string<br>    groups   = list(string)<br>  }))</pre> | `[]` | no |
| <a name="input_map_users"></a> [map\_users](#input\_map\_users) | Additional IAM users to add to the aws-auth configmap. | <pre>list(object({<br>    userarn  = string<br>    username = string<br>    groups   = list(string)<br>  }))</pre> | `[]` | no |
| <a name="input_patch"></a> [patch](#input\_patch) | Determines whether to patch the aws-auth configmap in-place with additional roles, users, and accounts. | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aws_auth_configmap_yaml"></a> [aws\_auth\_configmap\_yaml](#output\_aws\_auth\_configmap\_yaml) | Formatted yaml output for aws-auth configmap. |
| <a name="output_map_accounts"></a> [map\_accounts](#output\_map\_accounts) | The aws-auth map accounts. |
| <a name="output_map_roles"></a> [map\_roles](#output\_map\_roles) | The aws-auth map roles merged with the eks cluster node group and fargate profile roles. |
| <a name="output_map_users"></a> [map\_users](#output\_map\_users) | The aws-auth map users. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
