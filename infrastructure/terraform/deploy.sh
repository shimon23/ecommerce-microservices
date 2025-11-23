#!/bin/bash

# Deploy infrastructure - Use this at START of work day
# Estimated time: 10-12 minutes

echo "Deploying Azure infrastructure..."
echo "Estimated time: 10-12 minutes"
echo ""

# Check if logged in to Azure
if ! az account show &> /dev/null; then
    echo "Not logged in to Azure. Running 'az login'..."
    az login
fi

echo " zure login verified"
echo ""

# Initialize Terraform (if needed)
if [ ! -d ".terraform" ]; then
    echo "📦 Initializing Terraform..."
    terraform init
fi

# Validate configuration
echo "Validating Terraform configuration..."
terraform validate
if [ $? -ne 0 ]; then
    echo "Validation failed. Please fix errors and try again."
    exit 1
fi

# Show plan
echo ""
echo "Terraform Plan:"
terraform plan -out=tfplan

# Ask for confirmation
echo ""
read -p "pply this plan? (yes/no): " confirm
if [ "$confirm" != "yes" ]; then
    echo "Deployment cancelled"
    rm tfplan
    exit 0
fi

# Apply
echo ""
echo "Creating infrastructure..."
terraform apply tfplan
rm tfplan

if [ $? -eq 0 ]; then
    echo ""
    echo "Infrastructure deployed successfully!"
    echo ""
    echo "Next steps:"
    echo "  1. Get AKS credentials: ./connect-aks.sh"
    echo "  2. Deploy applications to AKS"
    echo ""
    echo "Remember to run './destroy.sh' at end of day to save costs!"
else
    echo ""
    echo "Deployment failed. Check errors above."
    exit 1
fi