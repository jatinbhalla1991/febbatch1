# Terraform EKS Demo

This directory contains Terraform code to create an AWS EKS (Elastic Kubernetes Service) cluster for demonstration purposes.

## Architecture

The Terraform code creates:

- **VPC**: Virtual Private Cloud with custom CIDR
- **Subnets**: 
  - 2 Public subnets (for load balancers)
  - 2 Private subnets (for EKS nodes)
- **Internet Gateway**: For public internet access
- **NAT Gateways**: For private subnet internet access (one per AZ)
- **EKS Cluster**: Managed Kubernetes control plane
- **EKS Node Group**: Managed worker nodes with auto-scaling
- **IAM Roles & Policies**: For cluster and node group permissions
- **EKS Add-ons**: vpc-cni, kube-proxy, coredns

## Prerequisites

1. **AWS CLI** installed and configured
   ```bash
   aws configure
   ```

2. **Terraform** installed (version >= 1.0)
   ```bash
   terraform version
   ```

3. **kubectl** installed (to interact with the cluster)
   ```bash
   kubectl version --client
   ```

4. **AWS credentials** with appropriate permissions

## File Structure

```
terraform-eks/
├── main.tf           # EKS cluster and node group configuration
├── vpc.tf            # VPC, subnets, NAT gateways, route tables
├── iam.tf            # IAM roles and policies
├── variables.tf      # Variable definitions
├── outputs.tf        # Output values
├── provider.tf       # Terraform and AWS provider configuration
├── terraform.tfvars  # Variable values (customize this)
└── README.md         # This file
```

## Quick Start

### 1. Initialize Terraform

```bash
cd terraform-eks
terraform init
```

### 2. Review Configuration

Edit `terraform.tfvars` to customize your cluster:

```hcl
cluster_name = "my-demo-cluster"
region = "us-east-1"
instance_types = ["t3.medium"]
desired_capacity = 2
```

### 3. Plan the Deployment

```bash
terraform plan
```

### 4. Create the Cluster

```bash
terraform apply
```

Type `yes` when prompted. This will take approximately 10-15 minutes.

### 5. Configure kubectl

After the cluster is created, configure kubectl:

```bash
aws eks update-kubeconfig --region us-east-1 --name demo-eks-cluster
```

### 6. Verify the Cluster

```bash
# Check cluster info
kubectl cluster-info

# List nodes
kubectl get nodes

# Check namespaces
kubectl get namespaces

# Check pods in all namespaces
kubectl get pods -A
```

## Configuration Options

### Instance Types

Modify in `terraform.tfvars`:
```hcl
instance_types = ["t3.small"]    # Cost-effective for demo
instance_types = ["t3.medium"]   # Recommended for demo
instance_types = ["t3.large"]    # For heavier workloads
```

### Node Group Scaling

```hcl
desired_capacity = 2  # Number of nodes to start with
min_capacity     = 1  # Minimum nodes
max_capacity     = 4  # Maximum nodes for auto-scaling
```

### Cost Optimization - Use SPOT Instances

```hcl
capacity_type = "SPOT"  # Much cheaper, but can be interrupted
```

### Multi-AZ Configuration

```hcl
availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]
```

## Estimated Costs

**Running costs** (approximate):

- EKS Control Plane: ~$73/month
- 2 x t3.medium nodes (ON_DEMAND): ~$60/month
- NAT Gateways (2): ~$65/month
- Data transfer and storage: Variable

**Total: ~$200/month**

**Cost savings:**
- Use SPOT instances for nodes: Save ~70%
- Use single NAT Gateway: Save ~$32/month (less redundancy)
- Shut down when not in use

## Deploy a Sample Application

After the cluster is running:

```bash
# Deploy a sample nginx application
kubectl create deployment nginx --image=nginx
kubectl expose deployment nginx --port=80 --type=LoadBalancer

# Check the service
kubectl get svc nginx

# Access the application (wait for EXTERNAL-IP)
curl <EXTERNAL-IP>
```

## Useful Commands

```bash
# Get cluster information
kubectl cluster-info

# View nodes
kubectl get nodes -o wide

# View all resources
kubectl get all -A

# Describe node
kubectl describe node <node-name>

# View EKS cluster from AWS CLI
aws eks describe-cluster --name demo-eks-cluster --region us-east-1

# Update kubeconfig
aws eks update-kubeconfig --name demo-eks-cluster --region us-east-1

# View terraform outputs
terraform output

# View sensitive outputs
terraform output cluster_certificate_authority_data
```

## Cleanup

To destroy all resources and avoid ongoing costs:

```bash
# Delete any LoadBalancer services first (to remove AWS LBs)
kubectl delete svc --all

# Wait a minute, then destroy with Terraform
terraform destroy
```

Type `yes` when prompted.

## Troubleshooting

### Nodes not joining the cluster

```bash
# Check node group status
aws eks describe-nodegroup \
  --cluster-name demo-eks-cluster \
  --nodegroup-name demo-eks-cluster-node-group \
  --region us-east-1
```

### kubectl connection issues

```bash
# Reconfigure kubectl
aws eks update-kubeconfig --name demo-eks-cluster --region us-east-1

# Test connection
kubectl get svc
```

### Access denied errors

Ensure your AWS credentials have the necessary permissions:
- EKS full access
- EC2 full access
- IAM policy management
- VPC management

## Security Recommendations

For production use:

1. **Restrict API access**: Update `public_access_cidrs` to your IP only
2. **Enable private endpoint**: Set `endpoint_private_access = true`
3. **Use private nodes**: Deploy nodes in private subnets only
4. **Enable encryption**: Add encryption for secrets
5. **Implement IRSA**: Use IAM Roles for Service Accounts
6. **Enable Pod Security Standards**
7. **Use AWS Secrets Manager** for sensitive data

## Next Steps

- Deploy your applications
- Configure ingress controller (nginx/ALB)
- Set up monitoring (CloudWatch, Prometheus)
- Configure autoscaling (Cluster Autoscaler/Karpenter)
- Implement CI/CD pipelines
- Configure logging (Fluent Bit)

## Resources

- [AWS EKS Documentation](https://docs.aws.amazon.com/eks/)
- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [Kubernetes Documentation](https://kubernetes.io/docs/)
