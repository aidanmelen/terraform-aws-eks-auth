output "aws_auth_yaml" {
  description = "The `aws-auth` config map YAML."
  value       = module.eks_auth.config_map_yaml
}
