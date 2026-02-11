# Cloud Cost Analysis Script
Write-Host "💰 Starting Cost Analysis..." -ForegroundColor Cyan

$ErrorActionPreference = "Continue"

# Infracost - Terraform costs
Write-Host "`n📊 Terraform Infrastructure Costs (Infracost)..." -ForegroundColor Yellow
if (Get-Command infracost -ErrorAction SilentlyContinue) {
    Write-Host "Running Infracost breakdown..." -ForegroundColor Gray
    infracost breakdown --path terraform/ --format table
    
    Write-Host "`nGenerating detailed JSON report..." -ForegroundColor Gray
    infracost breakdown --path terraform/ --format json --out-file terraform-costs.json
    
    Write-Host "`n✅ Cost report saved to terraform-costs.json" -ForegroundColor Green
} else {
    Write-Host "⚠️  Infracost not found. Install with:" -ForegroundColor Red
    Write-Host "   choco install infracost" -ForegroundColor Yellow
    Write-Host "   Then run: infracost auth login" -ForegroundColor Yellow
}

# AWS Cost Explorer (if AWS CLI configured)
Write-Host "`n📊 AWS Actual Costs (Last 30 days)..." -ForegroundColor Yellow
if (Get-Command aws -ErrorAction SilentlyContinue) {
    $endDate = (Get-Date).ToString("yyyy-MM-dd")
    $startDate = (Get-Date).AddDays(-30).ToString("yyyy-MM-dd")
    
    Write-Host "Fetching AWS costs from $startDate to $endDate..." -ForegroundColor Gray
    
    aws ce get-cost-and-usage `
        --time-period Start=$startDate,End=$endDate `
        --granularity MONTHLY `
        --metrics BlendedCost UnblendedCost `
        --output table
    
    # Cost by service
    Write-Host "`nTop 5 Services by Cost:" -ForegroundColor Cyan
    aws ce get-cost-and-usage `
        --time-period Start=$startDate,End=$endDate `
        --granularity MONTHLY `
        --metrics BlendedCost `
        --group-by Type=DIMENSION,Key=SERVICE `
        --output json | ConvertFrom-Json | Select-Object -ExpandProperty ResultsByTime | Select-Object -First 1 | Select-Object -ExpandProperty Groups | Sort-Object -Property @{Expression={[double]($_.Metrics.BlendedCost.Amount)}} -Descending | Select-Object -First 5 | Format-Table -Property @{Label="Service";Expression={$_.Keys[0]}}, @{Label="Cost (USD)";Expression={[math]::Round([double]($_.Metrics.BlendedCost.Amount), 2)}}
} else {
    Write-Host "⚠️  AWS CLI not found. Install from: https://aws.amazon.com/cli/" -ForegroundColor Red
}

# Azure Cost (if Azure CLI configured)
Write-Host "`n📊 Azure Actual Costs..." -ForegroundColor Yellow
if (Get-Command az -ErrorAction SilentlyContinue) {
    $azAccount = az account show 2>$null
    if ($azAccount) {
        Write-Host "Fetching Azure consumption data..." -ForegroundColor Gray
        az consumption usage list --top 10 --output table 2>$null
        
        if ($LASTEXITCODE -ne 0) {
            Write-Host "⚠️  Unable to fetch Azure costs. Check permissions." -ForegroundColor Red
        }
    } else {
        Write-Host "⚠️  Not logged into Azure. Run: az login" -ForegroundColor Red
    }
} else {
    Write-Host "⚠️  Azure CLI not found. Install from: https://aka.ms/installazurecliwindows" -ForegroundColor Red
}

# GCP Cost (if gcloud configured)
Write-Host "`n📊 GCP Costs..." -ForegroundColor Yellow
if (Get-Command gcloud -ErrorAction SilentlyContinue) {
    $gcpAccount = gcloud config get-value account 2>$null
    if ($gcpAccount) {
        Write-Host "Fetching GCP billing data..." -ForegroundColor Gray
        gcloud billing accounts list
    } else {
        Write-Host "⚠️  Not logged into GCP. Run: gcloud auth login" -ForegroundColor Red
    }
} else {
    Write-Host "⚠️  GCP CLI not found" -ForegroundColor Red
}

# Summary
Write-Host "`n" -NoNewline
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "✅ Cost analysis completed!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan

Write-Host "`n📁 Generated Files:" -ForegroundColor Cyan
if (Test-Path "terraform-costs.json") {
    Write-Host "   • terraform-costs.json (Infracost report)" -ForegroundColor White
}

Write-Host "`n💡 Tips:" -ForegroundColor Cyan
Write-Host "   • Review costs regularly" -ForegroundColor White
Write-Host "   • Set up budget alerts in cloud console" -ForegroundColor White
Write-Host "   • Tag resources for better cost tracking" -ForegroundColor White
Write-Host "   • Consider reserved instances for stable workloads" -ForegroundColor White
