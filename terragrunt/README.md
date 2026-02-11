# Terragrunt Example Project

## 📁 Directory Structure

```
terragrunt/
├── terragrunt.hcl                    # Root configuration (common settings)
├── environments/
│   ├── dev/
│   │   ├── terragrunt.hcl           # Dev environment config
│   │   ├── vpc/
│   │   │   └── terragrunt.hcl       # Dev VPC module config
│   │   └── ec2/
│   │       └── terragrunt.hcl       # Dev EC2 module config
│   ├── uat/
│   │   └── terragrunt.hcl           # UAT environment config
│   └── prod/
│       └── terragrunt.hcl           # Prod environment config
└── modules/
    ├── ec2/
    │   └── main.tf                   # EC2 Terraform module
    └── vpc/
        └── main.tf                   # VPC Terraform module
```

## 🚀 Installation

### Install Terragrunt

**Windows:**
```powershell
choco install terragrunt
```

**Linux/Mac:**
```bash
# Download latest release
curl -L https://github.com/gruntwork-io/terragrunt/releases/download/v0.55.0/terragrunt_linux_amd64 -o terragrunt
chmod +x terragrunt
sudo mv terragrunt /usr/local/bin/

# Or using Homebrew
brew install terragrunt
```

### Verify Installation
```bash
terragrunt --version
```

## 📝 Usage

### Initialize and Plan

**Single Environment:**
```bash
# Navigate to specific environment
cd terragrunt/environments/dev/ec2

# Initialize
terragrunt init

# Plan
terragrunt plan

# Apply
terragrunt apply
```

**All Modules in Environment:**
```bash
cd terragrunt/environments/dev

# Plan all modules
terragrunt run-all plan

# Apply all modules
terragrunt run-all apply

# Destroy all modules
terragrunt run-all destroy
```

### Work with Dependencies

Terragrunt automatically handles dependencies defined in `terragrunt.hcl`:

```bash
# This will automatically run VPC first, then EC2
cd terragrunt/environments/dev/ec2
terragrunt apply
```

### Common Commands

```bash
# Initialize all modules
terragrunt run-all init

# Validate all configurations
terragrunt run-all validate

# Format all Terraform files
terragrunt run-all fmt

# Show outputs
terragrunt output

# Refresh state
terragrunt refresh

# Show state
terragrunt state list
```

## 🎯 Key Features

### 1. **DRY Configuration**
- Root `terragrunt.hcl` contains common settings
- Environment configs inherit from root
- No duplicate backend/provider configuration

### 2. **Remote State Management**
- Automatic S3 backend configuration
- State file per module
- DynamoDB locking enabled

### 3. **Module Dependencies**
```hcl
dependencies {
  paths = ["../vpc", "../security"]
}
```

### 4. **Dynamic Inputs**
```hcl
inputs = {
  vpc_id = dependency.vpc.outputs.vpc_id
}
```

### 5. **Mock Outputs**
For planning without dependencies:
```hcl
dependency "vpc" {
  config_path = "../vpc"
  
  mock_outputs = {
    vpc_id = "vpc-mock-12345"
  }
}
```

## 🔧 Configuration Examples

### Root terragrunt.hcl
```hcl
remote_state {
  backend = "s3"
  config = {
    bucket = "my-terraform-state"
    key    = "${path_relative_to_include()}/terraform.tfstate"
    region = "us-east-1"
  }
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite"
  contents  = <<EOF
provider "aws" {
  region = var.aws_region
}
EOF
}
```

### Environment-Specific
```hcl
include "root" {
  path = find_in_parent_folders()
}

inputs = {
  environment    = "dev"
  instance_type  = "t2.micro"
}
```

### With Dependencies
```hcl
dependency "vpc" {
  config_path = "../vpc"
}

inputs = {
  vpc_id     = dependency.vpc.outputs.vpc_id
  subnet_ids = dependency.vpc.outputs.subnet_ids
}
```

## 💡 Best Practices

1. **Use run-all with caution**: Test with `plan` first
2. **Mock outputs**: Always provide for CI/CD
3. **Version control**: Include `terragrunt.hcl`, exclude `.terragrunt-cache/`
4. **State management**: One state file per module
5. **Dependencies**: Explicitly declare module dependencies
6. **Variables**: Use environment-specific values

## 🔄 Workflow

```bash
# 1. Create new environment
cd terragrunt/environments
cp -r dev staging

# 2. Update staging config
nano staging/terragrunt.hcl

# 3. Plan changes
cd staging
terragrunt run-all plan

# 4. Apply infrastructure
terragrunt run-all apply

# 5. Destroy when done
terragrunt run-all destroy
```

## 📊 Environment Comparison

| Environment | Instance Type | Count | NAT Gateway | Cost |
|-------------|---------------|-------|-------------|------|
| Dev         | t2.micro      | 1     | No          | Low  |
| UAT         | t2.small      | 2     | Yes         | Med  |
| Prod        | t3.medium     | 3     | Yes         | High |

## 🛠️ Troubleshooting

**Error: Provider not found**
```bash
terragrunt init
```

**Error: Dependency not applied**
```bash
cd ../vpc
terragrunt apply
cd ../ec2
terragrunt apply
```

**Clear cache**
```bash
rm -rf .terragrunt-cache/
terragrunt init
```

## 🔗 Resources

- **Terragrunt Docs**: https://terragrunt.gruntwork.io/
- **GitHub**: https://github.com/gruntwork-io/terragrunt
- **Examples**: https://github.com/gruntwork-io/terragrunt-infrastructure-live-example
