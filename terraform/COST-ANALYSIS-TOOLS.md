# Cloud Cost Analysis Tools

## Overview
Tools to estimate, analyze, and optimize cloud infrastructure costs before and after deployment.

---

## 💰 Cost Analysis Tools

### 1. **Infracost**
- **Purpose**: Cloud cost estimates for Terraform in CI/CD
- **Features**: 
  - Cost breakdown before apply
  - Pull request comments with cost impact
  - Support for AWS, Azure, GCP
  - Free for individuals
- **Installation**:
  ```bash
  # Windows (PowerShell)
  choco install infracost
  
  # Linux/Mac
  brew install infracost
  
  # Manual
  curl -fsSL https://raw.githubusercontent.com/infracost/infracost/master/scripts/install.sh | sh
  ```
- **Setup**:
  ```bash
  # Get API key (free)
  infracost auth login
  
  # Or set manually
  infracost configure set api_key YOUR_API_KEY
  ```
- **Usage**:
  ```bash
  # Cost breakdown
  infracost breakdown --path terraform/
  
  # Compare changes
  infracost diff --path terraform/
  
  # JSON output
  infracost breakdown --path terraform/ --format json
  
  # Show costs by service
  infracost breakdown --path terraform/ --format table
  
  # Multi-project
  infracost breakdown --config-file infracost.yml
  ```
- **Configuration** (infracost.yml):
  ```yaml
  version: 0.1
  projects:
    - path: terraform/dev
      name: dev-environment
    - path: terraform/prod
      name: prod-environment
  ```
- **Website**: https://www.infracost.io/

---

### 2. **Terraform Cost Estimation (Terraform Cloud)**
- **Purpose**: Native cost estimation in Terraform Cloud/Enterprise
- **Features**:
  - Integrated with Terraform workflow
  - Cost estimates in plan output
  - Historical cost tracking
- **Usage**: Automatic in Terraform Cloud
- **Pricing**: Requires Terraform Cloud Plus ($20/user/month)
- **Website**: https://www.terraform.io/cloud

---

### 3. **CloudHealth by VMware**
- **Purpose**: Multi-cloud cost management platform
- **Features**:
  - Cost optimization recommendations
  - Rightsizing suggestions
  - Reserved instance planning
  - Anomaly detection
- **Support**: AWS, Azure, GCP, private clouds
- **Pricing**: Contact for pricing
- **Website**: https://www.cloudhealthtech.com/

---

### 4. **AWS Cost Explorer**
- **Purpose**: AWS native cost analysis
- **Features**:
  - Historical cost data
  - Forecasting
  - Cost allocation tags
  - Free tier usage tracking
- **Usage**: AWS Console → Cost Explorer
- **API**: Available via AWS SDK
  ```bash
  aws ce get-cost-and-usage --time-period Start=2026-01-01,End=2026-02-01 --granularity MONTHLY --metrics BlendedCost
  ```
- **Pricing**: Free (API calls charged after 50 free)
- **Website**: https://aws.amazon.com/aws-cost-management/

---

### 5. **Azure Cost Management**
- **Purpose**: Azure native cost analysis
- **Features**:
  - Cost analysis and budgets
  - Recommendations
  - Exports to storage
- **Usage**: Azure Portal → Cost Management
- **Pricing**: Free
- **Website**: https://azure.microsoft.com/en-us/products/cost-management/

---

### 6. **GCP Cost Management**
- **Purpose**: Google Cloud native cost tools
- **Features**:
  - Cost breakdown
  - Budget alerts
  - Committed use discounts
- **Usage**: GCP Console → Billing
- **Pricing**: Free
- **Website**: https://cloud.google.com/cost-management

---

### 7. **Kubecost**
- **Purpose**: Kubernetes cost monitoring
- **Features**:
  - Real-time cost allocation
  - Namespace/pod level costs
  - Optimization recommendations
- **Installation**:
  ```bash
  helm repo add kubecost https://kubecost.github.io/cost-analyzer/
  helm install kubecost kubecost/cost-analyzer
  ```
- **Pricing**: Free tier available
- **Website**: https://www.kubecost.com/

---

### 8. **CloudZero**
- **Purpose**: Real-time cost intelligence
- **Features**:
  - Cost anomaly detection
  - Unit cost metrics
  - Engineering-focused insights
- **Pricing**: Contact for pricing
- **Website**: https://www.cloudzero.com/

---

### 9. **Spot by NetApp (formerly Cloudability)**
- **Purpose**: Multi-cloud cost optimization
- **Features**:
  - Rightsizing recommendations
  - Reserved instance planning
  - Container cost allocation
- **Pricing**: Tiered pricing
- **Website**: https://spot.io/

---

### 10. **Komiser**
- **Purpose**: Open-source cloud cost analyzer
- **Features**:
  - Multi-cloud support
  - Self-hosted
  - Resource visualization
- **Installation**:
  ```bash
  docker run -d -p 3000:3000 mlabouardy/komiser:latest
  ```
- **Pricing**: Free (open-source)
- **Website**: https://www.komiser.io/

---

## 📊 Comparison Table

| Tool | Type | Clouds | Terraform Integration | Free Tier | Best For |
|------|------|--------|----------------------|-----------|----------|
| **Infracost** | Pre-deployment | AWS, Azure, GCP | ✅ Excellent | ✅ Yes | Terraform users |
| **Terraform Cloud** | Native | All | ✅ Native | ❌ Paid | Enterprise Terraform |
| **CloudHealth** | Platform | Multi-cloud | ⚠️ Limited | ❌ No | Enterprise |
| **AWS Cost Explorer** | Native | AWS only | ❌ No | ✅ Yes | AWS users |
| **Azure Cost Mgmt** | Native | Azure only | ❌ No | ✅ Yes | Azure users |
| **GCP Cost Mgmt** | Native | GCP only | ❌ No | ✅ Yes | GCP users |
| **Kubecost** | Kubernetes | Multi-cloud | ⚠️ Limited | ✅ Yes | Kubernetes |
| **CloudZero** | Platform | Multi-cloud | ⚠️ Limited | ❌ No | SaaS companies |
| **Spot** | Platform | Multi-cloud | ⚠️ Limited | ❌ No | Enterprise |
| **Komiser** | Self-hosted | Multi-cloud | ❌ No | ✅ Yes | Open-source fans |

---

## 🚀 Quick Start with Infracost

### 1. Install and Setup
```powershell
# Install
choco install infracost

# Login (get free API key)
infracost auth login

# Or register at https://dashboard.infracost.io
```

### 2. Basic Usage
```bash
# Navigate to terraform directory
cd terraform/

# Get cost breakdown
infracost breakdown --path .

# Compare with main branch
infracost diff --path . --compare-to main
```

### 3. CI/CD Integration (GitHub Actions)
```yaml
- name: Setup Infracost
  uses: infracost/actions/setup@v3
  with:
    api-key: ${{ secrets.INFRACOST_API_KEY }}

- name: Generate Infracost JSON
  run: infracost breakdown --path=terraform/ --format=json --out-file=/tmp/infracost.json

- name: Post comment
  run: |
    infracost comment github --path=/tmp/infracost.json \
      --repo=$GITHUB_REPOSITORY \
      --github-token=${{ secrets.GITHUB_TOKEN }} \
      --pull-request=${{ github.event.pull_request.number }}
```

---

## 📈 Cost Optimization Script

Create `analyze-costs.ps1`:

```powershell
# Cloud Cost Analysis Script
Write-Host "💰 Starting Cost Analysis..." -ForegroundColor Cyan

# Infracost - Terraform costs
Write-Host "`n📊 Terraform Infrastructure Costs (Infracost)..." -ForegroundColor Yellow
if (Get-Command infracost -ErrorAction SilentlyContinue) {
    infracost breakdown --path terraform/ --format table
    infracost breakdown --path terraform/ --format json --out-file costs.json
    Write-Host "✅ Cost report saved to costs.json" -ForegroundColor Green
} else {
    Write-Host "⚠️  Infracost not found. Install: choco install infracost" -ForegroundColor Red
}

# AWS Cost Explorer (if AWS CLI configured)
Write-Host "`n📊 AWS Actual Costs (Last 30 days)..." -ForegroundColor Yellow
if (Get-Command aws -ErrorAction SilentlyContinue) {
    $endDate = (Get-Date).ToString("yyyy-MM-dd")
    $startDate = (Get-Date).AddDays(-30).ToString("yyyy-MM-dd")
    
    aws ce get-cost-and-usage `
        --time-period Start=$startDate,End=$endDate `
        --granularity MONTHLY `
        --metrics BlendedCost `
        --output table
} else {
    Write-Host "⚠️  AWS CLI not found" -ForegroundColor Red
}

# Azure Cost (if Azure CLI configured)
Write-Host "`n📊 Azure Actual Costs..." -ForegroundColor Yellow
if (Get-Command az -ErrorAction SilentlyContinue) {
    az consumption usage list --top 10 --output table 2>$null
    if ($LASTEXITCODE -ne 0) {
        Write-Host "⚠️  Run 'az login' first" -ForegroundColor Red
    }
} else {
    Write-Host "⚠️  Azure CLI not found" -ForegroundColor Red
}

Write-Host "`n✅ Cost analysis completed!" -ForegroundColor Green
```

Run with:
```powershell
.\analyze-costs.ps1
```

---

## 🎯 Best Practices

### 1. Pre-Deployment (Shift-Left)
- ✅ Use **Infracost** in CI/CD pipeline
- ✅ Review costs in pull requests
- ✅ Set cost thresholds for approvals

### 2. Post-Deployment
- ✅ Monitor with native tools (AWS Cost Explorer, etc.)
- ✅ Set up budget alerts
- ✅ Regular cost reviews (weekly/monthly)

### 3. Optimization
- ✅ Rightsize instances based on usage
- ✅ Use reserved instances for stable workloads
- ✅ Implement auto-scaling
- ✅ Clean up unused resources

### 4. Tagging Strategy
- ✅ Tag resources by: Environment, Team, Project, Cost Center
- ✅ Enable cost allocation tags
- ✅ Enforce tagging policies

---

## 📋 Cost Checklist

- [ ] Install Infracost for Terraform cost estimation
- [ ] Add Infracost to CI/CD pipeline
- [ ] Enable cloud provider cost tools
- [ ] Set up budget alerts
- [ ] Implement resource tagging
- [ ] Schedule monthly cost reviews
- [ ] Identify and remove unused resources
- [ ] Consider reserved instances for stable workloads
- [ ] Monitor cost anomalies
- [ ] Document cost optimization wins

---

## 🔗 Resources

- **Infracost**: https://www.infracost.io/docs/
- **AWS Cost Optimization**: https://aws.amazon.com/pricing/cost-optimization/
- **Azure Cost Management**: https://learn.microsoft.com/en-us/azure/cost-management-billing/
- **GCP Cost Optimization**: https://cloud.google.com/cost-management
- **FinOps Foundation**: https://www.finops.org/
