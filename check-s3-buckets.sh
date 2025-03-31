#!/bin/zsh

# This script:
# 1. Lists all S3 buckets in the AWS account
# 2. Creates a CSV file 'buckets.csv' with headers for bucket details
# 3. For each bucket, checks and records:
#    - Bucket name
#    - If public access is enabled
#    - If lifecycle policies are configured
#    - If the bucket is empty
#    - If versioning is enabled
# 4. Writes all findings to buckets.csv in CSV format
# 5. Outputs bucket details to console during processing


# Store the list of buckets in a array
buckets=($(aws s3api list-buckets --query 'Buckets[*].Name' --output text))

# write the header to the csv file: Bucket Name, Public Access, LifeCycle Policy
echo "Bucket Name, Public Access, LifeCycle Policy, Empty, Versioning" > buckets.csv

# Loop through the array and check if the bucket is public
for bucket in $buckets; do
    public="False"
    lifecycle="False"
    empty="False"
    version="True"
    
    # Print the bucket name
    echo $bucket
    
    # Check if the bucket is empty
    objects=$(aws s3api list-objects --bucket $bucket --query 'Contents' --output text --no-cli-pager --max-items 2)
    if [[ $objects == "None" ]]; then
        echo "Bucket is empty"
        empty="True"
    fi
    
    # Check if the bucket is public
    acl=$(aws s3api get-bucket-acl --bucket $bucket --query 'Grants[?Grantee.URI==`http://acs.amazonaws.com/groups/global/AllUsers`].Permission' --output text --no-cli-pager)
    echo $acl
    if [[ $acl == "READ" || $acl == "WRITE" || $acl == "READ_ACP" || $acl == "WRITE_ACP" ]]; then
        # If the bucket is public, check if it has a lifecycle policy
        echo "Bucket is public"
        public="True"
    fi
    
    # Check if the bucket has a lifecycle policy
    lf=$(aws s3api get-bucket-lifecycle-configuration --bucket $bucket --query 'Rules' --output text --no-cli-pager)
    if [[ $lf != "" ]]; then
        echo "Bucket has a lifecycle policy"
        lifecycle="True"
    fi
    
    # Check if the bucket has versioning enabled
    version=$(aws s3api get-bucket-versioning --bucket $bucket --query 'Status' --output text --no-cli-pager)
    if [[ $version != "Enabled" ]]; then
        version="False"    
    fi
    
    # Write the bucket name, public access and lifecycle policy to the csv file
    echo "$bucket, $public, $lifecycle, $empty, $version" >> buckets.csv
done