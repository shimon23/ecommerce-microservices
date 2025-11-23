# Destroy infrastructure - Use this at END of work day to save costs
# Estimated time: 5-8 minutes

Write-Host "Ì∑ëÔ∏è  Destroying Azure infrastructure to save costs..." -ForegroundColor Yellow
Write-Host "‚è±Ô∏è  Estimated time: 5-8 minutes`n"

# Show what will be destroyed
Write-Host "Ì≥ã Resources that will be destroyed:"
terraform plan -destroy

# Ask for confirmation
Write-Host ""
Write-Host "‚ö†Ô∏è  WARNING: This will delete ALL Azure resources!" -ForegroundColor Red
Write-Host "Ì≤æ Your Terraform state will be preserved - you can redeploy tomorrow"
Write-Host ""
$confirm = Read-Host "Ì¥î Are you sure you want to destroy? (yes/no)"

if ($confirm -ne "yes") {
    Write-Host "‚ùå Destruction cancelled - resources remain active" -ForegroundColor Yellow
    Write-Host "Ì≤∞ Remember: Resources are still costing money!" -ForegroundColor Red
    exit 0
}

# Destroy
Write-Host "`nÌ¥• Destroying infrastructure..."
terraform destroy -auto-approve

if ($LASTEXITCODE -eq 0) {
    Write-Host "`n‚úÖ All resources destroyed successfully!" -ForegroundColor Green
    Write-Host "`nÌ≤∞ Estimated savings: ~`$2-4 until next deployment"
    Write-Host "Ì≥ù To work again tomorrow: .\deploy.ps1"
} else {
    Write-Host "`n‚ùå Destruction failed. Check errors above." -ForegroundColor Red
    Write-Host "Ì≤° You may need to manually delete resources in Azure Portal"
    exit 1
}
