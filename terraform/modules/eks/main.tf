# Create EKS Cluster
resource "aws_eks_cluster" "eks_cluster" {
  name     = var.cluster_name
  role_arn = var.cluster_role_arn
  version  = var.k8s_version

  access_config {
    authentication_mode = "API"
    bootstrap_cluster_creator_admin_permissions = true
  }

  upgrade_policy {
    support_type = "STANDARD"
  }

  vpc_config {
    subnet_ids              = concat(var.public_subnets, var.private_subnets)
    endpoint_public_access  = true
    endpoint_private_access = true
    public_access_cidrs     = ["0.0.0.0/0"]
  }

  enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
}

# Managed Node Group
resource "aws_eks_node_group" "managed_nodes" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = var.nodegroup_name
  node_role_arn   = var.nodegroup_role_arn
  subnet_ids      = var.private_subnets

  scaling_config {
    desired_size = var.desired_capacity
    max_size     = var.max_capacity
    min_size     = var.min_capacity
  }

  remote_access {
    ec2_ssh_key               = "uts"
    source_security_group_ids = [var.node_sg_id]
  }

  instance_types = var.node_instance_types
  ami_type       = var.ami_type
  capacity_type  = var.capacity_type

  depends_on = [aws_eks_cluster.eks_cluster]
}

# EKS Add-ons via Terraform
resource "aws_eks_addon" "vpc_cni" {
  cluster_name                = aws_eks_cluster.eks_cluster.name
  addon_name                  = "vpc-cni"
  addon_version               = var.vpc_cni_version
}

resource "aws_eks_addon" "coredns" {
  cluster_name                = aws_eks_cluster.eks_cluster.name
  addon_name                  = "coredns"
  addon_version               = var.coredns_version
}

resource "aws_eks_addon" "kube_proxy" {
  cluster_name                = aws_eks_cluster.eks_cluster.name
  addon_name                  = "kube-proxy"
  addon_version               = var.kube_proxy_version
}

resource "aws_eks_addon" "cloudwatch_agent" {
  cluster_name                = aws_eks_cluster.eks_cluster.name
  addon_name                  = "amazon-cloudwatch-observability"
  addon_version               = var.cloudwatch_version
  service_account_role_arn    = var.cloudwatch_role_arn
}

resource "aws_eks_addon" "ebs_csi_driver" {
  cluster_name                = aws_eks_cluster.eks_cluster.name
  addon_name                  = "aws-ebs-csi-driver"
  addon_version               = var.ebs_version
  service_account_role_arn    = var.ebs_role_arn
}

resource "aws_eks_addon" "pod_identity_agent" {
  cluster_name                = aws_eks_cluster.eks_cluster.name
  addon_name                  = "eks-pod-identity-agent"
  addon_version               = var.pod_identity_version
}

# Associate EBS CSI Driver Role
resource "aws_eks_pod_identity_association" "ebs_csi" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  namespace       = "kube-system"
  service_account = "ebs-csi-controller-sa"
  role_arn        = var.ebs_role_arn
}

# Associate Load Balancer Controller Role
resource "aws_eks_pod_identity_association" "lbc" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  namespace       = "kube-system"
  service_account = "aws-load-balancer-controller"
  role_arn        = var.lbc_role_arn
}

# Associate CloudWatch Agent Role
resource "aws_eks_pod_identity_association" "cw_observability" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  namespace       = "amazon-cloudwatch"
  service_account = "cloudwatch-agent"
  role_arn        = var.cloudwatch_role_arn
}