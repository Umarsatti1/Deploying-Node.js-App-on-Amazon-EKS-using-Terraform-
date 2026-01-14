variable "cluster_name" {
  type = string
}

variable "k8s_version" {
  type = string
}

variable "cluster_role_arn" {
  type = string
}

variable "nodegroup_role_arn" {
  type = string
}

variable "vpc_role_arn" {
  type = string
}

variable "cloudwatch_role_arn" {
  type = string
}

variable "ebs_role_arn" {
  type = string
}

variable "lbc_role_arn" {
  type = string
}

variable "public_subnets" {
  type = list(string)
}

variable "private_subnets" {
  type = list(string)
}

variable "node_sg_id" {
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

# Add-on versions
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