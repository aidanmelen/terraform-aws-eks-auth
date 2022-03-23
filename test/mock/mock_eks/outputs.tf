output "cluster_id" {
  description = "mock"
  value       = "ex-mock"
}

output "eks_managed_node_groups" {
  description = "mock"
  value = {
    "foo" = {
      "iam_role_arn" = "arn:aws:iam::11111111111:role/foo-eks-node-group-20220323013727515700000001"
    }
  }
}

output "aws_auth_configmap_yaml" {
  description = "mock"
  value       = <<EOT
apiVersion: v1
kind: ConfigMap
metadata:
  name: aws-auth
  namespace: kube-system
data:
  mapRoles: |
    - rolearn: arn:aws:iam::11111111111:role/foo-eks-node-group-20220323013727515700000001
      username: system:node:{{EC2PrivateDNSName}}
      groups:
        - system:bootstrappers
        - system:nodes

EOT
}
