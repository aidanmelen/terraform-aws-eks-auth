# Archive Notice

The [`terraform-aws-modules/eks/aws` v.18.20.0 release](https://github.com/terraform-aws-modules/terraform-aws-eks/releases/tag/v18.20.0) has brought back support `aws-auth` configmap! For this reason, I highly encourage users to manage the `aws-auth` configmap with the EKS module.

I am planning to archive this repo on May 1st, 2022. You are welcome to open an issue here if you are having trouble with the migration steps below and will do my best to help.


# Migration:

## steps

1. Remove the `aidanmelen/eks-auth/aws` declaration for your terraform code.
2. Remove the `aidanmelen/eks-auth/aws` resources from terraform state.
  - The `aws-auth` should no long be managed by this module.
  - A plan should show that there are no infrastructure changes to the EKS cluster.
3. Upgrade the version of the EKS module: `version = ">= v18.20.0"`
4. Configure the `terraform-aws-modules/eks/aws` with `manage_aws_auth_configmap = true`. This version of the EKS module uses the new `kubernetes_config_map_v1_data` resource to patch `aws-auth` data.
5. Plan and Apply.
  - The `aws-auth` configmap should now be managed by the EKS module.

Please see the [complete example](https://registry.terraform.io/modules/terraform-aws-modules/eks/aws/latest) for more information.

---

[![Pre-Commit](https://github.com/aidanmelen/terraform-aws-eks-auth/actions/workflows/pre-commit.yaml/badge.svg)](https://github.com/aidanmelen/terraform-aws-eks-auth/actions/workflows/pre-commit.yaml)
[![cookiecutter-tf-module](https://img.shields.io/badge/cookiecutter--tf--module-enabled-brightgreen)](https://github.com/aidanmelen/cookiecutter-tf-module)

# terraform-aws-eks-auth

A Terraform module to manage [cluster authentication](https://docs.aws.amazon.com/eks/latest/userguide/cluster-auth.html) for an Elastic Kubernetes (EKS) cluster on AWS.

## Assumptions

- You are using the [terraform-aws-eks](https://registry.terraform.io/modules/terraform-aws-modules/eks/aws/latest) module.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->


## Usage

Grant access to the AWS EKS cluster by adding `map_roles`, `map_user` or `map_accounts` to the `aws-auth` configmap.

```hcl
module "eks" {
  source = "terraform-aws-modules/eks/aws"
  # insert the 15 required variables here
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

Please see the [complete example](examples/complete) for more information.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14.8 |
| <a name="requirement_http"></a> [http](#requirement\_http) | >= 2.4.1 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 2.10.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_http"></a> [http](#provider\_http) | >= 2.4.1 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | >= 2.10.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [kubernetes_config_map_v1.aws_auth](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/config_map_v1) | resource |
| [kubernetes_config_map_v1_data.aws_auth](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/config_map_v1_data) | resource |
| [http_http.wait_for_cluster](https://registry.terraform.io/providers/terraform-aws-modules/http/latest/docs/data-sources/http) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_eks"></a> [eks](#input\_eks) | The outputs from the `terraform-aws-modules/terraform-aws-eks` module. | `any` | n/a | yes |
| <a name="input_map_accounts"></a> [map\_accounts](#input\_map\_accounts) | Additional AWS account numbers to add to the aws-auth configmap. | `list(string)` | `[]` | no |
| <a name="input_map_roles"></a> [map\_roles](#input\_map\_roles) | Additional IAM roles to add to the aws-auth configmap. | <pre>list(object({<br>    rolearn  = string<br>    username = string<br>    groups   = list(string)<br>  }))</pre> | `[]` | no |
| <a name="input_map_users"></a> [map\_users](#input\_map\_users) | Additional IAM users to add to the aws-auth configmap. | <pre>list(object({<br>    userarn  = string<br>    username = string<br>    groups   = list(string)<br>  }))</pre> | `[]` | no |
| <a name="input_wait_for_cluster_timeout"></a> [wait\_for\_cluster\_timeout](#input\_wait\_for\_cluster\_timeout) | A timeout (in seconds) to wait for cluster to be available. | `number` | `300` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aws_auth_configmap_yaml"></a> [aws\_auth\_configmap\_yaml](#output\_aws\_auth\_configmap\_yaml) | Formatted yaml output for aws-auth configmap. |
| <a name="output_map_accounts"></a> [map\_accounts](#output\_map\_accounts) | The aws-auth map accounts. |
| <a name="output_map_roles"></a> [map\_roles](#output\_map\_roles) | The aws-auth map roles merged with the eks managed node group, self managed node groups and fargate profile roles. |
| <a name="output_map_users"></a> [map\_users](#output\_map\_users) | The aws-auth map users. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## License

Apache 2 Licensed. See [LICENSE](https://github.com/aidanmelen/terraform-aws-eks-auth/tree/master/LICENSE) for full details.
