#!/bin/zsh

# This script:
# 1. Lists all AWS regions
# 2. Retrieves VPC information for each region
# 3. Displays VPC IDs for each region
# 4. Outputs VPC details to console during processing

# Retrieve all AWS regions
regions=($(aws ec2 describe-regions --query "Regions[].RegionName" --output text))

# Iterate over each region
for region in $regions; do
  echo "Region: $region"
  
  # Retrieve VPC information for the current region
  vpcs=$(aws ec2 describe-vpcs --region $region --query "Vpcs[].VpcId" --output text)
  echo $vpcs
  
  # Check if VPCs exist in the region
  if [ -n "$vpcs" ]; then
    echo "VPCs:"
    
    # Iterate over each VPC and display its ID
    for vpc in $vpcs; do
      echo "  $vpc"
    done
  else
    echo "No VPCs found in this region."
  fi
  
  echo
done