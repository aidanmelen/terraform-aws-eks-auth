output "config_map" {
  description = "The `aws-auth` config map."
  value       = kubernetes_config_map.aws_auth
}

output "config_map_yaml" {
  description = "The `aws-auth` config map YAML."
  value       = yamlencode(kubernetes_config_map.aws_auth)
}
