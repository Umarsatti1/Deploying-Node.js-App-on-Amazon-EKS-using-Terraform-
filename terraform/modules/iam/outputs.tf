output "cluster_role_arn" {
  value = aws_iam_role.eks_cluster_role.arn
}

output "nodegroup_role_arn" {
  value = aws_iam_role.eks_nodegroup_role.arn
}

output "vpc_role_arn" {
  value = aws_iam_role.eks_vpc_addons_role.arn
}

output "cloudwatch_role_arn" {
  value = aws_iam_role.eks_cloudwatch_addons_role.arn
}

output "ebs_role_arn" {
  value = aws_iam_role.eks_ebs_addons_role.arn
}

output "lbc_role_arn" {
  value = aws_iam_role.eks_lbc_addons_role.arn
}