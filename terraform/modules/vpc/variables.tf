# VPC Variables
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