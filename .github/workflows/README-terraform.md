# Terraform GitHub Actions Pipeline

## Overview
This pipeline automates Terraform deployments with token replacement in `terraform.tfvars`.

## Pipeline Jobs

### 1. **replace-tokens**
- Replaces tokens in `terraform.tfvars` with values from GitHub Secrets/Variables
- Uploads the modified file as an artifact

### 2. **terraform-plan**
- Downloads the modified `terraform.tfvars`
- Runs `terraform init`, `validate`, and `plan`
- Comments the plan on pull requests

### 3. **terraform-apply**
- Applies the Terraform plan
- Runs only on:
  - Manual trigger with "apply" action
  - Push to main branch

### 4. **terraform-destroy**
- Destroys infrastructure
- Runs only on manual trigger with "destroy" action

## Token Replacement

The pipeline replaces these tokens in `terraform.tfvars.template`:

| Token | Replaced With | Source |
|-------|---------------|--------|
| `__ENVIRONMENT__` | dev/uat/prod | Workflow input |
| `__AWS_REGION__` | AWS region | Secret: `AWS_REGION` |
| `__BUCKET_NAME__` | S3 bucket name | Secret: `BUCKET_NAME` |
| `__AMI_ID__` | AMI ID | Secret: `AMI_ID` |
| `__INSTANCE_TYPE__` | Instance type | Variable: `INSTANCE_TYPE` |
| `__INSTANCE_COUNT__` | Number of instances | Variable: `INSTANCE_COUNT` |

## Required GitHub Secrets

Set these in: **Settings → Secrets and variables → Actions → Secrets**

```
AWS_ACCESS_KEY_ID      - Your AWS access key
AWS_SECRET_ACCESS_KEY  - Your AWS secret key
AWS_REGION            - AWS region (e.g., us-east-1)
BUCKET_NAME           - S3 bucket name
AMI_ID                - EC2 AMI ID
```

## Required GitHub Variables

Set these in: **Settings → Secrets and variables → Actions → Variables**

```
INSTANCE_TYPE   - EC2 instance type (default: t2.micro)
INSTANCE_COUNT  - Number of instances (default: 1)
```

## Usage

### Automatic Trigger
Push changes to `terraform/` folder:
```bash
git add terraform/
git commit -m "Update terraform config"
git push origin main
```

### Manual Trigger
1. Go to **Actions** tab
2. Select "Terraform CI/CD Pipeline"
3. Click "Run workflow"
4. Select:
   - Environment (dev/uat/prod)
   - Action (plan/apply/destroy)
5. Click "Run workflow"

## File Structure

```
terraform/
├── terraform.tfvars.template  # Template with tokens
├── terraform.tfvars           # Generated (not in git)
├── providers.tf
├── main.tf
└── variables.tf

.github/workflows/
└── terraform.yml              # Pipeline definition
```

## Example terraform.tfvars.template

```hcl
environment    = "__ENVIRONMENT__"
aws_region     = "__AWS_REGION__"
bucket_name    = "__BUCKET_NAME__"
ami_id         = "__AMI_ID__"
instance_type  = "__INSTANCE_TYPE__"
instance_count = __INSTANCE_COUNT__
```

After token replacement:
```hcl
environment    = "prod"
aws_region     = "us-east-1"
bucket_name    = "my-prod-bucket"
ami_id         = "ami-0c55b159cbfafe1f0"
instance_type  = "t2.micro"
instance_count = 3
```
