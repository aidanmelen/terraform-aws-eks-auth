output "aws_auth_yaml" {
  description = "The `aws-auth` config map YAML."
  value       = module.aws_auth.config_map_yaml
}
