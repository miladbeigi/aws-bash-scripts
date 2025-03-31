#!/bin/bash

# This script:
# 1. Retrieves the hosted zone ID for a given domain name
# 2. Lists all resource record sets in the hosted zone
# 3. Saves the records to a CSV file


# Check if domain name is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <domain_name>"
  exit 1
fi

DOMAIN_NAME=$1

# Get the hosted zone ID based on domain name
HOSTED_ZONE_ID=$(aws route53 list-hosted-zones-by-name \
    --dns-name "$DOMAIN_NAME" \
    --query 'HostedZones[0].Id' \
    --output text | sed 's|/hostedzone/||')

if [ -z "$HOSTED_ZONE_ID" ] || [ "$HOSTED_ZONE_ID" = "None" ]; then
  echo "Hosted zone for domain $DOMAIN_NAME not found."
  exit 1
fi

echo "Hosted Zone ID: $HOSTED_ZONE_ID"

OUTPUT_FILE="${DOMAIN_NAME}_records.csv"

# Header of CSV file
echo "Name,Type,TTL,Value" > "$OUTPUT_FILE"

# Get all records and append to CSV
aws route53 list-resource-record-sets --hosted-zone-id "$HOSTED_ZONE_ID" \
  --query 'ResourceRecordSets[*].[Name,Type,TTL,ResourceRecords[*].Value]' \
  --output json |
  jq -r '.[] | [.[0], .[1], (.[2] // ""), (.[3][]? // "")] | @csv' >> "$OUTPUT_FILE"

echo "Records saved to $OUTPUT_FILE"
