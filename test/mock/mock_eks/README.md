# mock_eks sub-module

A null module that outputs mock values that would normally be outputted by the terraform-aws-eks module. This has the advantage of being able to test the `eks_auth` module without waiting for AWS VPC and AWS EKS Cluster to provision... which can take approximately 13 minutes. In this way, we can assert the contents of `aws-auth` configmap on a local kubernetes cluster given a specific set of `mock_eks` outputs.
