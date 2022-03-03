output "eks_aws_auth_configmap_yaml" {
  description = "Formatted yaml output for the aws-auth configmap containing the provided roles, users and accounts merged with the eks roles used in cluster node groups/fargate profiles."
  value       = module.eks_auth.configmap_yaml
}
