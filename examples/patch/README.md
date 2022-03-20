<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->


# Patch Example

The aws-auth configmap will be patched in-place with additional roles, users, and accounts.

```hcl
module "eks_auth" {
  source = "../../"
  eks    = module.eks
  patch  = true

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

## Running this module manually

1. Install [Terraform](https://www.terraform.io/) and make sure it's on your `PATH`.
1. Run `terraform init`.
1. Run `terraform apply`.
1. When you're done, run `terraform destroy`.

## Running automated tests against this module

1. Install [Terraform](https://www.terraform.io/) and make sure it's on your `PATH`.
1. Install [Golang](https://golang.org/) and make sure this code is checked out into your `GOPATH`.
1. `cd test`
1. `go test terraform_patch_test.go -v`

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.72 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 1.11.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 3.72 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_eks"></a> [eks](#module\_eks) | terraform-aws-modules/eks/aws | >= 18.0.0 |
| <a name="module_eks_auth"></a> [eks\_auth](#module\_eks\_auth) | ../../ | n/a |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-aws-modules/vpc/aws | ~> 3.0 |

## Resources

| Name | Type |
|------|------|
| [aws_eks_cluster.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster) | data source |
| [aws_eks_cluster_auth.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster_auth) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | The AWS Region | `string` | `"us-west-2"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_fargate_profile_iam_role_arn"></a> [fargate\_profile\_iam\_role\_arn](#output\_fargate\_profile\_iam\_role\_arn) | The Amazon Resource Name (ARN) of the EKS Fargate Profile |
| <a name="output_managed_node_group_iam_role_arn"></a> [managed\_node\_group\_iam\_role\_arn](#output\_managed\_node\_group\_iam\_role\_arn) | The Amazon Resource Name (ARN) specifying the IAM role for the managed node group |
| <a name="output_map_accounts"></a> [map\_accounts](#output\_map\_accounts) | The aws-auth map accounts |
| <a name="output_map_roles"></a> [map\_roles](#output\_map\_roles) | The aws-auth map roles merged with the eks cluster node group and fargate profile roles |
| <a name="output_map_users"></a> [map\_users](#output\_map\_users) | The aws-auth map users |
| <a name="output_self_managed_node_group_iam_role_arn"></a> [self\_managed\_node\_group\_iam\_role\_arn](#output\_self\_managed\_node\_group\_iam\_role\_arn) | The Amazon Resource Name (ARN) specifying the IAM role for the self managed node group |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
