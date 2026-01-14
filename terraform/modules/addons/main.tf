# Install AWS Load Balancer Controller via Helm
resource "helm_release" "lb_controller" {
  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  namespace  = "kube-system"

  set = [
    {
      name  = "clusterName"
      value = var.cluster_name
    },

    {
      name  = "serviceAccount.create"
      value = "true"
    },

    {
      name  = "serviceAccount.name"
      value = "aws-load-balancer-controller"
    },

    {
      name  = "region"
      value = var.aws_region
    },

    {
      name  = "vpcId"
      value = var.vpc_id
    }
  ]
}



