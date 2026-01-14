# Local Variables
locals {
  public_subnets = {
    Public-Subnet-A = {
      cidr = var.public_cidr_a
      az   = var.az_a
    }
    Public-Subnet-B = {
      cidr = var.public_cidr_b
      az   = var.az_b
    }
  }
  private_subnets = {
    Private-Subnet-A = {
      cidr = var.private_cidr_a
      az   = var.az_a
    }
    Private-Subnet-B = {
      cidr = var.private_cidr_b
      az   = var.az_b
    }
  }
  private_to_nat = {
    Private-Subnet-A = "Public-Subnet-A"
    Private-Subnet-B = "Public-Subnet-B"
  }
}

# VPC CIDR
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = var.vpc_name
  }
}

# Public Subnets
resource "aws_subnet" "public_subnet" {
  for_each                = local.public_subnets
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = each.value.az
  cidr_block              = each.value.cidr
  map_public_ip_on_launch = true

  tags = {
    Name                                          = each.key
    "kubernetes.io/role/elb"                      = "1"
    "kubernetes.io/cluster/umarsatti-eks-cluster" = "shared"
  }
}

# Private Subnets
resource "aws_subnet" "private_subnet" {
  for_each          = local.private_subnets
  vpc_id            = aws_vpc.vpc.id
  availability_zone = each.value.az
  cidr_block        = each.value.cidr

  tags = {
    Name                                          = each.key
    "kubernetes.io/role/internal-elb"             = "1"
    "kubernetes.io/cluster/umarsatti-eks-cluster" = "shared"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = var.igw_name
  }
}

# Elastic IP and NAT Gateway
resource "aws_eip" "eip" {
  for_each = aws_subnet.public_subnet
  domain   = var.eip_domain

  tags = {
    Name = "Nat-EIP-${each.key}"
  }
}

resource "aws_nat_gateway" "nat" {
  for_each = aws_subnet.public_subnet

  allocation_id = aws_eip.eip[each.key].id
  subnet_id     = each.value.id

  tags = {
    Name = "Nat-GW-${each.key}"
  }
}

# Public Route Tables
resource "aws_route_table" "public_rt" {
  for_each = aws_subnet.public_subnet
  vpc_id   = aws_vpc.vpc.id

  route {
    cidr_block = var.public_route
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${each.key}-RT"
  }
}

# Private Route Tables
resource "aws_route_table" "private_rt" {
  for_each = aws_subnet.private_subnet
  vpc_id   = aws_vpc.vpc.id

  tags = {
    Name = "${each.key}-RT"
  }
}

# Public Route Table Association
resource "aws_route_table_association" "public_rta" {
  for_each       = aws_subnet.public_subnet
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public_rt[each.key].id
}

# Private Route Table Association
resource "aws_route_table_association" "private_rta" {
  for_each       = aws_subnet.private_subnet
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private_rt[each.key].id
}

# Private Route Table NAT Route
resource "aws_route" "private_nat_route" {
  for_each               = aws_subnet.private_subnet
  destination_cidr_block = var.public_route
  route_table_id         = aws_route_table.private_rt[each.key].id
  nat_gateway_id         = aws_nat_gateway.nat[local.private_to_nat[each.key]].id
}

# Node Security Group
resource "aws_security_group" "node_sg" {
  name        = "umarsatti-eks-node-sg"
  description = "Security group for all nodes in the cluster"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    self      = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name                                          = "umarsatti-eks-node-sg"
    "kubernetes.io/cluster/umarsatti-eks-cluster" = "owned"
  }
}