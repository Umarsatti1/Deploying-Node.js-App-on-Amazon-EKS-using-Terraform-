variable "vpc_cidr" {
  type = string
}

variable "vpc_name" {
  type = string
}

variable "igw_name" {
  type = string
}

variable "eip_domain" {
  type = string
}

variable "public_route" {
  type = string
}

variable "public_cidr_a" {
  type = string
}

variable "public_cidr_b" {
  type = string
}

variable "private_cidr_a" {
  type = string
}

variable "private_cidr_b" {
  type = string
}

variable "az_a" {
  type = string
}

variable "az_b" {
  type = string
}

# IAM Variables
variable "cluster_role_name" {
  type = string
}

variable "nodegroup_role_name" {
  type = string
}

variable "vpc_role_name" {
  type = string
}

variable "cloudwatch_role_name" {
  type = string
}

variable "ebs_role_name" {
  type = string
}

variable "loadbalancer_role_name" {
  type = string
}

variable "loadbalancer_policy_name" {
  type = string
}

# ECR Variables
variable "ecr_repository_name" {
  type = string
}

variable "ecr_mutability" {
  type = string
}

variable "ecr_encryption" {
  type = string
}

# EKS Variables
variable "cluster_name" {
  type = string
}

variable "k8s_version" {
  type = string
}

variable "nodegroup_name" {
  type = string
}

variable "desired_capacity" {
  type = number
}

variable "max_capacity" {
  type = number
}

variable "min_capacity" {
  type = number
}

variable "node_instance_types" {
  type = list(string)
}

variable "ami_type" {
  type = string
}

variable "capacity_type" {
  type = string
}

variable "vpc_cni_version" {
  type = string
}

variable "coredns_version" {
  type = string
}

variable "kube_proxy_version" {
  type = string
}

variable "cloudwatch_version" {
  type = string
}

variable "ebs_version" {
  type = string
}

variable "pod_identity_version" {
  type = string
}

# LBC
variable "aws_region" {
  type = string
}
