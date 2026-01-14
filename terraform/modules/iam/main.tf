# Define Trust Relationships

# 1. EC2 Trust Relationship
data "aws_iam_policy_document" "ec2_entity" {
  statement {
    effect = "Allow"
    actions = [
      "sts:AssumeRole"
    ]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

# 2. EKS Trust Relationship
data "aws_iam_policy_document" "eks_entity" {
  statement {
    effect = "Allow"
    actions = [
      "sts:AssumeRole"
    ]

    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
  }
}

# 3. EKS Pods Service Trust Relationship
data "aws_iam_policy_document" "eks_pods_entity" {
  statement {
    effect = "Allow"
    actions = [
      "sts:AssumeRole",
      "sts:TagSession"
    ]

    principals {
      type        = "Service"
      identifiers = ["pods.eks.amazonaws.com"]
    }
  }
}

# 1. EKS Cluster IAM Role and Policies
# Create EKS Cluster IAM Role
resource "aws_iam_role" "eks_cluster_role" {
  name               = var.cluster_role_name
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.eks_entity.json
}

# Attach AWS Managed IAM Policy to the EKS Cluster IAM Role
resource "aws_iam_role_policy_attachment" "eks_cluster_policy_attachment" {
  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

# 2. EKS Managed Node Group IAM Role and Policies
# Create EKS Node Group IAM Role
resource "aws_iam_role" "eks_nodegroup_role" {
  name               = var.nodegroup_role_name
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.ec2_entity.json
}

# Attach AWS Managed IAM Policies to the EKS Node Group IAM Role
resource "aws_iam_role_policy_attachment" "eks_nodegroup_policies" {
  for_each = toset([
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  ])
  role       = aws_iam_role.eks_nodegroup_role.name
  policy_arn = each.value
}

# 3. EKS VPC Add-ons IAM Role and Policies
# Create EKS VPC add-ons IAM Role
resource "aws_iam_role" "eks_vpc_addons_role" {
  name               = var.vpc_role_name
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.eks_pods_entity.json
}

# 4. EKS CloudWatch Add-ons IAM Role and Policies
# Create EKS CloudWatch add-ons IAM Role
resource "aws_iam_role" "eks_cloudwatch_addons_role" {
  name               = var.cloudwatch_role_name
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.eks_pods_entity.json
}

# Attach AWS Managed IAM Policy to the EKS CloudWatch Add-ons IAM Role
resource "aws_iam_role_policy_attachment" "eks_cloudwatch_policy_attachment" {
  role       = aws_iam_role.eks_cloudwatch_addons_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

# 5. EKS EBS CSI Driver Add-ons IAM Role and Policies
# Create EKS EBS add-ons IAM Role
resource "aws_iam_role" "eks_ebs_addons_role" {
  name               = var.ebs_role_name
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.eks_pods_entity.json
}

# Attach AWS Managed IAM Policy to the EKS VPC Add-ons IAM Role
resource "aws_iam_role_policy_attachment" "eks_ebs_policy_attachment" {
  role       = aws_iam_role.eks_ebs_addons_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
}

# 6. EKS Load Balancer Controller Add-ons IAM Role and Policies
# Create EKS Load Balancer Controller add-ons IAM Role
resource "aws_iam_role" "eks_lbc_addons_role" {
  name               = var.loadbalancer_role_name
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.eks_pods_entity.json
}

# Create the IAM Policy for Load Balancer
resource "aws_iam_policy" "lbc_inline_policy" {
  name        = var.loadbalancer_policy_name
  description = "Permissions for the Application Load Balancer (read from JSON file)"
  policy      = file("${path.root}/lbc-policy.json")
}

# Attach the IAM Policy to the IAM Role
resource "aws_iam_role_policy_attachment" "eb_service_policy_attachment" {
  role       = aws_iam_role.eks_lbc_addons_role.name
  policy_arn = aws_iam_policy.lbc_inline_policy.arn
}