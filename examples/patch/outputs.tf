output "fargate_profile_iam_role_arn" {
  description = "The Amazon Resource Name (ARN) of the EKS Fargate Profile"
  value       = module.eks.fargate_profiles.bar.iam_role_arn
}

output "node_group_iam_role_arn" {
  description = "The Amazon Resource Name (ARN) specifying the IAM role for the managed node group"
  value       = module.eks.eks_managed_node_groups.foo.iam_role_arn
}

output "map_accounts" {
  description = "The aws-auth map accounts"
  value       = module.eks_auth.map_accounts
}

output "map_roles" {
  description = "The aws-auth map roles merged with the eks cluster node group and fargate profile roles"
  value       = module.eks_auth.map_roles
}

output "map_users" {
  description = "The aws-auth map users"
  value       = module.eks_auth.map_users
}
