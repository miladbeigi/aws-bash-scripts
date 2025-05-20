#!/bin/bash

TAG_KEY="dd_monitoring"

# Get all AWS regions
regions=$(aws ec2 describe-regions --query "Regions[].RegionName" --output text)

for region in $regions; do
  echo "Processing region: $region"

  # Get instance IDs that have tags (to avoid unnecessary calls)
  instance_ids=$(aws ec2 describe-instances \
    --region "$region" \
    --query "Reservations[].Instances[?Tags].InstanceId" \
    --output text)

  if [ -z "$instance_ids" ]; then
    echo "No tagged instances found in region $region."
    continue
  fi

  echo "Removing tag '$TAG_KEY' from instances in region $region: $instance_ids"

  aws ec2 delete-tags \
    --region "$region" \
    --resources $instance_ids \
    --tags Key="$TAG_KEY"

  if [ $? -eq 0 ]; then
    echo "Successfully removed tag in $region."
  else
    echo "Failed to remove tag in $region."
  fi

done

