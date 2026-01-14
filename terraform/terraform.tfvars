# VPC
vpc_cidr       = "172.20.0.0/16"
vpc_name       = "umarsatti-vpc"
igw_name       = "umarsatti-igw"
eip_domain     = "vpc"
public_route   = "0.0.0.0/0"
public_cidr_a  = "172.20.10.0/24"
public_cidr_b  = "172.20.20.0/24"
private_cidr_a = "172.20.30.0/24"
private_cidr_b = "172.20.40.0/24"
az_a           = "us-west-1a"
az_b           = "us-west-1b"

# IAM
cluster_role_name        = "uts-eks-cluster-role"
nodegroup_role_name      = "uts-eks-node-group-role"
vpc_role_name            = "uts-eks-vpc-addons-role"
cloudwatch_role_name     = "uts-eks-cloudwatch-addons-role"
ebs_role_name            = "uts-eks-ebs-addons-role"
loadbalancer_role_name   = "uts-eks-lbc-role"
loadbalancer_policy_name = "uts-aws-lb-controller-iam-policy"

# ECR
ecr_repository_name = "nodejs-eks-repo"
ecr_mutability      = "MUTABLE"
ecr_encryption      = "AES256"

# EKS
cluster_name         = "umarsatti-eks-cluster"
k8s_version          = "1.33"
nodegroup_name       = "umarsatti-node-group"
desired_capacity     = 2
max_capacity         = 2
min_capacity         = 2
ami_type             = "AL2023_x86_64_STANDARD"
capacity_type        = "ON_DEMAND"
node_instance_types  = ["t3.medium"]
vpc_cni_version      = "v1.21.1-eksbuild.1"
coredns_version      = "v1.12.4-eksbuild.1"
kube_proxy_version   = "v1.33.5-eksbuild.2"
cloudwatch_version   = "v5.0.0-eksbuild.1"
ebs_version          = "v1.54.0-eksbuild.1"
pod_identity_version = "v1.3.10-eksbuild.2"

# LBC
aws_region = "us-west-1"