output "cluster_id" {
  description = "mock"
  value       = "ex-mock"
}

output "cluster_endpoint" {
  description = "mock"
  value       = "https://kubernetes.docker.internal:6443"
}

output "cluster_certificate_authority_data" {
  description = "mock"
  value       = "LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUMvakNDQWVhZ0F3SUJBZ0lCQURBTkJna3Foa2lHOXcwQkFRc0ZBREFWTVJNd0VRWURWUVFERXdwcmRXSmwKY201bGRHVnpNQjRYRFRJeU1ETXlNakUzTlRFME9Wb1hEVE15TURNeE9URTNOVEUwT1Zvd0ZURVRNQkVHQTFVRQpBeE1LYTNWaVpYSnVaWFJsY3pDQ0FTSXdEUVlKS29aSWh2Y05BUUVCQlFBRGdnRVBBRENDQVFvQ2dnRUJBTHdnCnRibk9qaEpkM080UEdUSFB5V3V1SnorMTFuVzNNRXAwWVAxK2FHakYxSml4ckloU0Q4N1F5UEZXc3kzMG9tR1MKL0xQbmZJSDREWnB0MGkyeWF1eThTdjhiZEZPSHVqWlZrbHlZbFRIYndSWi8yY0xmRmtrNERRdzdIQ0gxTHpqbwphcU51UGxGWk9kYUkvS00zZis2TkpuNTk5OEpqUDZudXN6Sm03NzlkUUJST3c4OGcvbkg2TVVjRFhUYW84L0xiClVTZS9LcGhsbHpZNHFQRzIxYUQvZEViVGdmVzNZeFBnQ0NHTzdBNUN1a2tBdEkwMEkrazZHellaMnZZUmdlekoKRnM4TTAydEl0alN6MGpsV1JiQzNPTklmRmF4M2F3SGxqeDhOQkx4QTlVRFc1aEhnNzNuUnRqTk8xSEd6TUFiYwpKUDVyTG9VWHZJSHUrS1FTdWJFQ0F3RUFBYU5aTUZjd0RnWURWUjBQQVFIL0JBUURBZ0trTUE4R0ExVWRFd0VCCi93UUZNQU1CQWY4d0hRWURWUjBPQkJZRUZIZWkyNnpZais2Y2ViM3JxMlBTNWRJeTc2S0NNQlVHQTFVZEVRUU8KTUF5Q0NtdDFZbVZ5Ym1WMFpYTXdEUVlKS29aSWh2Y05BUUVMQlFBRGdnRUJBRHFZbGZhRWxOb2dvVUMyMFVxRgpJdU5tWmcySzJ1YW8xbDBNb3pMZ3NUZmhvSkNSNTF4NDR1cjZVL1M4M05SY3F6bVlnVG84NkNKMmI2aFFOa0VhCk5jWXd0N2t2Nzc0ZVNuaFhVSXdWYW5ETk5wQjh2YlV3M1pzbDB5V21hNXlyVnVIMk9pbWMvVHB2Ni9UbU1hV04KVjhFYlhiaEhhUEpTS0pzNjZOQmd1SXRXdGg4VFBySnFLbnpZSUwzbFV6VHVGajNmQTd6Zm1GYnhITjg5VjVUVQpTbGwzazN0MzMrUy9tZFZHSmFnaVVvNG84QW5ZVGRMUnYvcWFzZDgvNlhhQ1lmcUtZS25BUGk3S202Ykl4YU1CCmZrS1BEaDM1ZEZ2WDNWRHEvT2NIVjU2ZmFadWJnK0NaTElGMk9UaVJuLytIYU1sTGJzdStnaXVWbStLVzg2QmEKWUQ0PQotLS0tLUVORCBDRVJUSUZJQ0FURS0tLS0tCg=="
}

output "eks_managed_node_groups" {
  description = "mock"
  value = {
    "foo" = {
      "iam_role_arn" = "arn:aws:iam::11111111111:role/foo-eks-node-group-20220323013727515700000001"
    }
  }
}

output "self_managed_node_groups" {
  description = "mock"
  value = {
    "boo" = {
      "iam_role_arn" = "arn:aws:iam::11111111111:role/boo-node-group-20220323151009311600000004"
    }
  }
}

output "fargate_profiles" {
  description = "mock"
  value = {
    "bar" = {
      "iam_role_arn" = "arn:aws:iam::11111111111:role/bar-20220323151009311300000003"
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
    - rolearn: arn:aws:iam::11111111111:role/boo-node-group-20220323013727515700000001
      username: system:node:{{EC2PrivateDNSName}}
      groups:
        - system:bootstrappers
        - system:nodes
    - rolearn: arn:aws:iam::11111111111:role/bar-20220323151009311300000003
      username: system:node:{{SessionName}}
      groups:
        - system:bootstrappers
        - system:nodes
        - system:node-proxier
EOT
}
