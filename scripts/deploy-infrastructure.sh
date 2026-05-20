#!/bin/bash
set -e
echo "🚀 Deploying StartTech Infrastructure..."
cd terraform
terraform init
terraform plan -out=tfplan
terraform apply -auto-approve tfplan
echo "✅ Deployment complete. Run 'terraform output' to see endpoints."
cd ..
