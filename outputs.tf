output "map_roles" {
  description = "The aws-auth map roles merged with the eks cluster node group and fargate profile roles."
  value       = local.merged_map_roles
}

output "map_users" {
  description = "The aws-auth map users."
  value       = var.map_users
}

output "map_accounts" {
  description = "The aws-auth map accounts."
  value       = var.map_accounts
}
