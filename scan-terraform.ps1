# Terraform Security Scan Script
Write-Host "🔍 Starting Terraform Security Scans..." -ForegroundColor Cyan

$ErrorActionPreference = "Continue"

# TFSec
Write-Host "`n📊 Running TFSec..." -ForegroundColor Yellow
if (Get-Command tfsec -ErrorAction SilentlyContinue) {
    tfsec terraform/ --format json --out tfsec-results.json
    tfsec terraform/
} else {
    Write-Host "⚠️  TFSec not found. Install: choco install tfsec" -ForegroundColor Red
}

# Checkov
Write-Host "`n📊 Running Checkov..." -ForegroundColor Yellow
if (Get-Command checkov -ErrorAction SilentlyContinue) {
    checkov -d terraform/ --compact
} else {
    Write-Host "⚠️  Checkov not found. Install: pip install checkov" -ForegroundColor Red
}

# TFLint
Write-Host "`n📊 Running TFLint..." -ForegroundColor Yellow
if (Get-Command tflint -ErrorAction SilentlyContinue) {
    Set-Location terraform
    tflint --init
    tflint
    Set-Location ..
} else {
    Write-Host "⚠️  TFLint not found. Install: choco install tflint" -ForegroundColor Red
}

# Terrascan
Write-Host "`n📊 Running Terrascan..." -ForegroundColor Yellow
if (Get-Command terrascan -ErrorAction SilentlyContinue) {
    terrascan scan -i terraform -d terraform/
} else {
    Write-Host "⚠️  Terrascan not found. Download from: https://github.com/tenable/terrascan/releases" -ForegroundColor Red
}

# Snyk (if authenticated)
Write-Host "`n📊 Running Snyk IaC..." -ForegroundColor Yellow
if (Get-Command snyk -ErrorAction SilentlyContinue) {
    snyk iac test terraform/ --severity-threshold=medium
} else {
    Write-Host "⚠️  Snyk not found. Install: npm install -g snyk" -ForegroundColor Red
}

Write-Host "`n✅ All scans completed!" -ForegroundColor Green
Write-Host "`nResults saved in: tfsec-results.json" -ForegroundColor Cyan
