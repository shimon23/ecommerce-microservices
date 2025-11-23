# Deploy infrastructure - Use this at START of work day
# Estimated time: 10-12 minutes

Write-Host "Deploying Azure infrastructure..." -ForegroundColor Green
Write-Host "Estimated time: 10-12 minutes`n"

# Check if logged in to Azure
$account = az account show 2>$null
if (-not $account) {
    Write-Host "Not logged in to Azure. Running 'az login'..." -ForegroundColor Red
    az login
}

Write-Host "Azure login verified`n" -ForegroundColor Green

# Initialize Terraform (if needed)
if (-not (Test-Path ".terraform")) {
    Write-Host "Initializing Terraform..."
    terraform init
}

# Validate configuration
Write-Host "🔍 Validating Terraform configuration..."
terraform validate
if ($LASTEXITCODE -ne 0) {
    Write-Host "Validation failed. Please fix errors and try again." -ForegroundColor Red
    exit 1
}

# Show plan
Write-Host "`nTerraform Plan:"
terraform plan -out=tfplan

# Ask for confirmation
Write-Host ""
$confirm = Read-Host " Apply this plan? (yes/no)"
if ($confirm -ne "yes") {
    Write-Host "Deployment cancelled" -ForegroundColor Yellow
    Remove-Item tfplan -ErrorAction SilentlyContinue
    exit 0
}

# Apply
Write-Host "`n Creating infrastructure..."
terraform apply tfplan
Remove-Item tfplan -ErrorAction SilentlyContinue

if ($LASTEXITCODE -eq 0) {
    Write-Host "Infrastructure deployed successfully!" -ForegroundColor Green
    Write-Host "Next steps:"
    Write-Host "  1. Get AKS credentials: .\connect-aks.ps1"
    Write-Host "  2. Deploy applications to AKS"
    Write-Host "`Remember to run '.\destroy.ps1' at end of day to save costs!" -ForegroundColor Yellow
} else {
    Write-Host " Deployment failed. Check errors above." -ForegroundColor Red
    exit 1
}