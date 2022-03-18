apiVersion: v1
kind: ConfigMap
metadata:
  name: aws-auth
  namespace: kube-system
data:
  mapRoles: |
    ${indent(4, yamlencode(map_roles))}
  mapUsers: |
    ${indent(4, yamlencode(map_users))}
  mapAccounts: |
    ${indent(4, yamlencode(map_accounts))}
