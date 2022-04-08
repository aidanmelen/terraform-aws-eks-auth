output "map_accounts" {
  description = "The aws-auth map accounts."
  value       = module.eks_auth.map_accounts
}

output "map_roles" {
  description = "The aws-auth map roles merged with the eks cluster node group and fargate profile roles."
  value       = module.eks_auth.map_roles
}

output "map_users" {
  description = "The aws-auth map users."
  value       = module.eks_auth.map_users
}
