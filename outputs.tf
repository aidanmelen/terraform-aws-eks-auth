output "configmap" {
  description = "The aws-auth configmap containing the provided roles, users and accounts merged with the eks roles used in cluster node groups/fargate profiles."
  value       = kubernetes_config_map.aws_auth
}

output "configmap_yaml" {
  description = "Formatted yaml output for the aws-auth configmap containing the provided roles, users and accounts merged with the eks roles used in cluster node groups/fargate profiles."
  value       = yamlencode(kubernetes_config_map.aws_auth)
}
