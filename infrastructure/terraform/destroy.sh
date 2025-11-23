#!/bin/bash

# Destroy infrastructure - Use this at END of work day to save costs
# Estimated time: 5-8 minutes

echo "Ì∑ëÔ∏è  Destroying Azure infrastructure to save costs..."
echo "‚è±Ô∏è  Estimated time: 5-8 minutes"
echo ""

# Show what will be destroyed
echo "Ì≥ã Resources that will be destroyed:"
terraform plan -destroy

# Ask for confirmation
echo ""
echo "‚ö†Ô∏è  WARNING: This will delete ALL Azure resources!"
echo "Ì≤æ Your Terraform state will be preserved - you can redeploy tomorrow"
echo ""
read -p "Ì¥î Are you sure you want to destroy? (yes/no): " confirm

if [ "$confirm" != "yes" ]; then
    echo "‚ùå Destruction cancelled - resources remain active"
    echo "Ì≤∞ Remember: Resources are still costing money!"
    exit 0
fi

# Destroy
echo ""
echo "Ì¥• Destroying infrastructure..."
terraform destroy -auto-approve

if [ $? -eq 0 ]; then
    echo ""
    echo "‚úÖ All resources destroyed successfully!"
    echo ""
    echo "Ì≤∞ Estimated savings: ~\$2-4 until next deployment"
    echo "Ì≥ù To work again tomorrow: ./deploy.sh"
else
    echo ""
    echo "‚ùå Destruction failed. Check errors above."
    echo "Ì≤° You may need to manually delete resources in Azure Portal"
    exit 1
fi
