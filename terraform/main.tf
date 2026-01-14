# VPC Module
module "vpc" {
  source         = "./modules/vpc"
  vpc_cidr       = var.vpc_cidr
  vpc_name       = var.vpc_name
  igw_name       = var.igw_name
  eip_domain     = var.eip_domain
  public_route   = var.public_route
  public_cidr_a  = var.public_cidr_a
  public_cidr_b  = var.public_cidr_b
  private_cidr_a = var.private_cidr_a
  private_cidr_b = var.private_cidr_b
  az_a           = var.az_a
  az_b           = var.az_b
}

# IAM Module
module "iam" {
  source                   = "./modules/iam"
  cluster_role_name        = var.cluster_role_name
  nodegroup_role_name      = var.nodegroup_role_name
  vpc_role_name            = var.vpc_role_name
  cloudwatch_role_name     = var.cloudwatch_role_name
  ebs_role_name            = var.ebs_role_name
  loadbalancer_role_name   = var.loadbalancer_role_name
  loadbalancer_policy_name = var.loadbalancer_policy_name
}

# ECR Module
module "ecr" {
  source              = "./modules/ecr"
  ecr_repository_name = var.ecr_repository_name
  ecr_mutability      = var.ecr_mutability
  ecr_encryption      = var.ecr_encryption
}

# EKS Module
module "eks" {
  source               = "./modules/eks"
  cluster_name         = var.cluster_name
  k8s_version          = var.k8s_version
  cluster_role_arn     = module.iam.cluster_role_arn
  public_subnets = module.vpc.public_subnets
  private_subnets      = module.vpc.private_subnets
  node_sg_id           = module.vpc.node_sg_id
  nodegroup_role_arn   = module.iam.nodegroup_role_arn
  vpc_role_arn         = module.iam.vpc_role_arn
  cloudwatch_role_arn  = module.iam.cloudwatch_role_arn
  ebs_role_arn         = module.iam.ebs_role_arn
  lbc_role_arn         = module.iam.lbc_role_arn
  nodegroup_name       = var.nodegroup_name
  desired_capacity     = 2
  max_capacity         = 2
  min_capacity         = 2
  node_instance_types  = var.node_instance_types
  ami_type             = var.ami_type
  capacity_type        = var.capacity_type
  vpc_cni_version      = var.vpc_cni_version
  coredns_version      = var.coredns_version
  kube_proxy_version   = var.kube_proxy_version
  cloudwatch_version   = var.cloudwatch_version
  ebs_version          = var.ebs_version
  pod_identity_version = var.pod_identity_version

  depends_on = [
    module.iam
  ]
}

module "lbc" {
  source       = "./modules/addons"
  aws_region   = var.aws_region
  vpc_id       = module.vpc.vpc_id
  cluster_name = module.eks.cluster_name
  depends_on = [
    module.eks
  ]
}
