output "vpc_id" {
  value       = aws_vpc.vpc.id
  description = "This is the VPC ID"
}

output "public_subnets" {
  value       = [for subnet in aws_subnet.public_subnet : subnet.id]
  description = "VPC Public Subnet IDs"
}

output "private_subnets" {
  value       = [for subnet in aws_subnet.private_subnet : subnet.id]
  description = "VPC Private Subnet IDs"
}

output "node_sg_id" {
  value       = aws_security_group.node_sg.id
  description = "Node Security Group ID"
}