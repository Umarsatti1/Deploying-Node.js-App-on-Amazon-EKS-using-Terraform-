# Deploying Node.js Application on Amazon EKS using Terraform 

## Overview
This project implements a fully automated AWS Kubernetes platform using Terraform and Amazon EKS. It provisions networking, IAM, container registry, Kubernetes cluster, managed node groups, and observability components. A containerized Node.js application is deployed using Kubernetes manifests and exposed externally through an AWS Application Load Balancer managed by the AWS Load Balancer Controller.

---

## Architecture

<p align="center">
  <img src="./diagram/Architecture Diagram.png" alt="Architecture Diagram" width="900">
</p>

The architecture consists of:
- Custom VPC with public and private subnets across two AZs
- Internet Gateway and NAT Gateways
- Amazon EKS cluster with managed node groups
- IAM roles and policies for cluster, nodes, and add-ons
- Amazon ECR for container images
- AWS Load Balancer Controller (ALB Ingress) using Helm
- Amazon EBS CSI Driver for persistent storage
- Amazon CloudWatch Container Insights for logs and metrics

---

## Project Structure
```
.
├── app/
│   ├── app.js
│   ├── package.json
│   ├── index.html
│   └── Dockerfile
├── terraform/
│   ├── main.tf
│   ├── variables.tf
│   ├── terraform.tf
│   ├── terraform.tfvars
│   └── modules/
│       ├── vpc/
│       ├── iam/
│       ├── ecr/
│       ├── eks/
│       └── addons/
└── k8s/
    ├── storageclass.yaml
    ├── statefulset.yaml
    ├── service.yaml
    └── ingress.yaml
```

---

## Infrastructure Provisioning
Terraform is used to provision:
- VPC, subnets, route tables, IGW, and NAT Gateways
- IAM roles for EKS, node groups, and add-ons
- Amazon EKS cluster with managed node groups
- Core EKS add-ons (VPC CNI, CoreDNS, kube-proxy, EBS CSI, CloudWatch)
- AWS Load Balancer Controller via Helm

### Terraform Commands
```bash
terraform init
terraform validate
terraform plan
terraform apply
```

---

## Kubernetes Deployment
Kubernetes manifests deploy the application:
- **StorageClass**: gp3 EBS volumes using CSI
- **StatefulSet**: 2 replicas with persistent volumes
- **Service**: NodePort for internal routing
- **Ingress**: Internet-facing ALB

Resource creation includes Pods, PVCs, PVs, Services, Ingress, and ALB.

---

## Observability
- CloudWatch Container Insights enabled
- Log groups created for cluster, performance, application, dataplane, and host logs
- Metrics collected at cluster, node, and pod level

---

## Cleanup
```bash
kubectl delete ingress node-app-ingress
kubectl delete service node-app-service
kubectl delete statefulset node-app
kubectl delete storageclass ebs-sc
terraform destroy -auto-approve
```

---

## Troubleshooting Highlights
- IMDSv2 metadata access issues resolved by explicitly passing VPC ID and region
- Service account and Pod Identity misconfigurations corrected
- YAML syntax errors fixed
- Storage AZ constraints resolved using StatefulSets
- CloudWatch Observability fixed via Pod Identity Association

---

## Conclusion
This project demonstrates end-to-end infrastructure automation and Kubernetes workload deployment on AWS using Terraform, EKS, and managed AWS services. It highlights best practices for networking, IAM, storage, ingress, and observability in a production-style Kubernetes environment.
