# Terraform Code Scanning Tools

## Overview
Tools to scan Terraform code for security issues, misconfigurations, and best practices.

---

## 🔒 Security Scanning Tools

### 1. **TFSec**
- **Purpose**: Security scanner for Terraform code
- **Features**: Detects potential security issues in AWS, Azure, GCP resources
- **Installation**:
  ```bash
  # Windows (using Chocolatey)
  choco install tfsec
  
  # Linux/Mac
  brew install tfsec
  
  # Or download binary from GitHub releases
  ```
- **Usage**:
  ```bash
  cd terraform/
  tfsec .
  tfsec . --format json > tfsec-results.json
  tfsec . --minimum-severity MEDIUM
  ```
- **Website**: https://aquasecurity.github.io/tfsec/

---

### 2. **Checkov**
- **Purpose**: Policy-as-code scanner for IaC
- **Features**: 1000+ built-in policies, custom policies, compliance frameworks
- **Installation**:
  ```bash
  pip install checkov
  ```
- **Usage**:
  ```bash
  checkov -d terraform/
  checkov -d terraform/ --framework terraform
  checkov -d terraform/ --check CKV_AWS_79
  checkov -d terraform/ --compact
  ```
- **Website**: https://www.checkov.io/

---

### 3. **Terrascan**
- **Purpose**: Static code analyzer for IaC
- **Features**: 500+ policies, multi-cloud support, admission controller
- **Installation**:
  ```bash
  # Windows
  curl -L "$(curl -s https://api.github.com/repos/tenable/terrascan/releases/latest | grep -o -E 'https://.+?_Windows_x86_64.tar.gz')" > terrascan.tar.gz
  tar -xf terrascan.tar.gz
  
  # Linux/Mac
  curl -L "$(curl -s https://api.github.com/repos/tenable/terrascan/releases/latest | grep -o -E 'https://.+?_Darwin_x86_64.tar.gz')" > terrascan.tar.gz
  tar -xf terrascan.tar.gz
  ```
- **Usage**:
  ```bash
  terrascan scan -i terraform -d terraform/
  terrascan scan -i terraform -d terraform/ -t aws
  terrascan scan -i terraform -d terraform/ -o json
  ```
- **Website**: https://runterrascan.io/

---

### 4. **TFLint**
- **Purpose**: Terraform linter
- **Features**: Detects errors, warns deprecated syntax, enforces best practices
- **Installation**:
  ```bash
  # Windows (using Chocolatey)
  choco install tflint
  
  # Linux/Mac
  brew install tflint
  ```
- **Usage**:
  ```bash
  cd terraform/
  tflint --init
  tflint
  tflint --format json
  tflint --recursive
  ```
- **Configuration** (.tflint.hcl):
  ```hcl
  plugin "aws" {
    enabled = true
    version = "0.29.0"
    source  = "github.com/terraform-linters/tflint-ruleset-aws"
  }
  ```
- **Website**: https://github.com/terraform-linters/tflint

---

### 5. **Snyk IaC**
- **Purpose**: Security scanning with developer-first approach
- **Features**: Real-time scanning, fix suggestions, integrations
- **Installation**:
  ```bash
  npm install -g snyk
  snyk auth
  ```
- **Usage**:
  ```bash
  snyk iac test terraform/
  snyk iac test terraform/ --severity-threshold=high
  snyk iac test terraform/ --json
  ```
- **Website**: https://snyk.io/product/infrastructure-as-code-security/

---

### 6. **Terraform Sentinel**
- **Purpose**: Policy-as-code framework (HashiCorp)
- **Features**: Fine-grained policies, Terraform Cloud/Enterprise
- **Usage**: Integrated with Terraform Cloud
- **Website**: https://www.terraform.io/docs/cloud/sentinel/

---

### 7. **OPA (Open Policy Agent)**
- **Purpose**: General-purpose policy engine
- **Features**: Rego policy language, flexible policies
- **Installation**:
  ```bash
  # Download from https://www.openpolicyagent.org/docs/latest/#running-opa
  ```
- **Website**: https://www.openpolicyagent.org/

---

### 8. **Infracost**
- **Purpose**: Cloud cost estimation
- **Features**: Shows cost of changes before apply
- **Installation**:
  ```bash
  # Windows (using Chocolatey)
  choco install infracost
  
  # Linux/Mac
  brew install infracost
  ```
- **Usage**:
  ```bash
  infracost breakdown --path terraform/
  infracost diff --path terraform/
  ```
- **Website**: https://www.infracost.io/

---

## 🚀 Quick Scan Script

Create a file `scan-terraform.ps1`:

```powershell
# Terraform Security Scan Script
Write-Host "🔍 Starting Terraform Security Scans..." -ForegroundColor Cyan

# TFSec
Write-Host "`n📊 Running TFSec..." -ForegroundColor Yellow
tfsec terraform/ --format json --out tfsec-results.json
tfsec terraform/

# Checkov
Write-Host "`n📊 Running Checkov..." -ForegroundColor Yellow
checkov -d terraform/ --compact

# TFLint
Write-Host "`n📊 Running TFLint..." -ForegroundColor Yellow
cd terraform
tflint --init
tflint
cd ..

# Terrascan
Write-Host "`n📊 Running Terrascan..." -ForegroundColor Yellow
terrascan scan -i terraform -d terraform/

# Snyk (if authenticated)
Write-Host "`n📊 Running Snyk IaC..." -ForegroundColor Yellow
snyk iac test terraform/ --severity-threshold=medium

Write-Host "`n✅ All scans completed!" -ForegroundColor Green
```

Run with:
```bash
powershell -ExecutionPolicy Bypass -File scan-terraform.ps1
```

---

## 📊 Comparison Table

| Tool | Focus | Languages | Cloud Support | Free Tier |
|------|-------|-----------|---------------|-----------|
| **TFSec** | Security | Terraform | AWS, Azure, GCP | ✅ Yes |
| **Checkov** | Security + Compliance | Multi-IaC | All Major Clouds | ✅ Yes |
| **Terrascan** | Security + Compliance | Multi-IaC | All Major Clouds | ✅ Yes |
| **TFLint** | Linting + Best Practices | Terraform | All | ✅ Yes |
| **Snyk** | Security + Developer UX | Multi-IaC | All Major Clouds | ⚠️ Limited |
| **Sentinel** | Policy | Terraform | All | ❌ Paid |
| **Infracost** | Cost Estimation | Terraform | AWS, Azure, GCP | ⚠️ Limited |

---

## 🎯 Recommended Workflow

1. **Local Development**: Use TFLint for quick feedback
2. **Pre-commit**: Run TFSec for security checks
3. **CI/CD Pipeline**: Run all tools (TFSec, Checkov, Terrascan)
4. **PR Review**: Infracost for cost impact
5. **Production**: Sentinel policies (if using Terraform Cloud)

---

## 📝 Pre-commit Hook

Create `.pre-commit-config.yaml`:

```yaml
repos:
  - repo: https://github.com/antonbabenko/pre-commit-terraform
    rev: v1.83.5
    hooks:
      - id: terraform_fmt
      - id: terraform_validate
      - id: terraform_tflint
      - id: terraform_tfsec
      - id: terraform_checkov
```

Install:
```bash
pip install pre-commit
pre-commit install
```

---

## 🔗 Resources

- TFSec: https://aquasecurity.github.io/tfsec/
- Checkov: https://www.checkov.io/
- Terrascan: https://runterrascan.io/
- TFLint: https://github.com/terraform-linters/tflint
- Snyk: https://snyk.io/
- Infracost: https://www.infracost.io/
