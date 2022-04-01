<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->


# Mock Example

Run `eks_auth` module against kubernetes running in docker-desktop. We mock out the terraform-aws-eks module outputs with the [mock_eks](./mock_eks) sub-module

```hcl
module "eks" {
  source = "./mock_eks"
}


module "eks_auth" {
  source = "../../"
  eks    = module.eks

  map_roles = [
    {
      rolearn  = "arn:aws:iam::66666666666:role/role1"
      username = "role1"
      groups   = ["system:masters"]
    },
  ]

  # map_users = [
  #   {
  #     userarn  = "arn:aws:iam::66666666666:user/user1"
  #     username = "user1"
  #     groups   = ["system:masters"]
  #   },
  #   {
  #     userarn  = "arn:aws:iam::66666666666:user/user2"
  #     username = "user2"
  #     groups   = ["system:masters"]
  #   },
  # ]

  # map_accounts = [
  #   "777777777777",
  #   "888888888888",
  # ]
}
```

## Running this module manually

1. Install [Terraform](https://www.terraform.io/) and make sure it's on your `PATH`.
1. Run `terraform init`.
1. Run `terraform apply`.
1. When you're done, run `terraform destroy`.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.1 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 2.10.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_eks"></a> [eks](#module\_eks) | ./mock_eks | n/a |
| <a name="module_eks_auth"></a> [eks\_auth](#module\_eks\_auth) | ../../ | n/a |

## Resources

No resources.

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_map_accounts"></a> [map\_accounts](#output\_map\_accounts) | The aws-auth map accounts. |
| <a name="output_map_roles"></a> [map\_roles](#output\_map\_roles) | The aws-auth map roles merged with the eks cluster node group and fargate profile roles. |
| <a name="output_map_users"></a> [map\_users](#output\_map\_users) | The aws-auth map users. |
| <a name="output_node_group_iam_role_arn"></a> [node\_group\_iam\_role\_arn](#output\_node\_group\_iam\_role\_arn) | The Amazon Resource Name (ARN) specifying the IAM role for the managed node group |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
