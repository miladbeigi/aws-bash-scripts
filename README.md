# aws-bash-scripts

A collection of bash scripts for managing and reporting on AWS resources.

## Prerequisites

Before using these scripts, ensure you have the following installed and configured:

*   **AWS CLI**: Configured with necessary permissions to access your AWS account. You can find installation instructions [here](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html).
*   **jq**: A lightweight and flexible command-line JSON processor. Required by `save-route53-records.sh`. Installation instructions can be found [here](https://stedolan.github.io/jq/download/).
*   **Shell**: Most scripts are written for `zsh` or `bash`. Ensure you have a compatible shell. `save-route53-records.sh` specifically uses `bash`, while `check-s3-buckets.sh` and `list-manage-vpc-all-regions.sh` use `zsh`.

## Scripts

### 1. `check-s3-buckets.sh`

*   **Purpose**: Lists all S3 buckets in your AWS account and checks various configurations for each bucket. It outputs the findings to the console and saves them in a `buckets.csv` file in the current directory.
*   **Details Checked**:
    *   Bucket Name
    *   Public Access (detects if `AllUsers` group has `READ`, `WRITE`, `READ_ACP`, or `WRITE_ACP` permissions)
    *   Lifecycle Policy (checks if any lifecycle rules are configured)
    *   Is Empty (checks if the bucket contains any objects)
    *   Versioning Status (checks if versioning is `Enabled`)
*   **Usage**:
    ```bash
    ./check-s3-buckets.sh
    ```
*   **Output**:
    *   Console: Prints details for each bucket as it's processed.
    *   File: `buckets.csv` with columns: `Bucket Name, Public Access, LifeCycle Policy, Empty, Versioning`.
*   **Prerequisites**:
    *   AWS CLI configured.
    *   `zsh` shell.

### 2. `list-manage-vpc-all-regions.sh`

*   **Purpose**: Lists all Virtual Private Clouds (VPCs) across all AWS regions.
*   **Usage**:
    ```bash
    ./list-manage-vpc-all-regions.sh
    ```
*   **Output**:
    *   Console: Prints the region followed by a list of VPC IDs in that region.
*   **Prerequisites**:
    *   AWS CLI configured.
    *   `zsh` shell.

### 3. `save-route53-records.sh`

*   **Purpose**: Retrieves all DNS resource record sets for a specified domain from AWS Route53 and saves them to a CSV file.
*   **Usage**:
    ```bash
    ./save-route53-records.sh <your_domain_name>
    ```
    Example:
    ```bash
    ./save-route53-records.sh example.com
    ```
*   **Output**:
    *   Console: Prints the Hosted Zone ID found for the domain.
    *   File: `<your_domain_name>_records.csv` with columns: `Name,Type,TTL,Value`.
*   **Prerequisites**:
    *   AWS CLI configured.
    *   `jq` installed.
    *   `bash` shell.

## Potential Enhancements & Contributing

This repository is a work in progress, and there are several areas for improvement. Contributions are welcome!

**General Script Enhancements:**
*   **Error Handling**: Improve checks for AWS CLI command success and other potential failures.
*   **AWS Profile Support**: Add an option (e.g., `-p <profile_name>` or `--profile <profile_name>`) to use a specific AWS CLI named profile.
*   **Consistent Argument Parsing**: Implement robust command-line argument parsing (e.g., using `getopts`).
*   **Help Option**: Add a `-h` or `--help` flag to display usage instructions for each script.
*   **Configuration File**: For common parameters (like default AWS region or profile), consider supporting a configuration file.
*   **Shebang Consistency**: Standardize shell interpreters (e.g., to `#!/usr/bin/env bash` for wider compatibility, or clearly document `zsh` dependencies).
*   **Tool Dependency Checks**: Implement explicit checks for necessary command-line tools (`aws`, `jq`) at the beginning of each script and provide user-friendly error messages if they are missing.

**Script-Specific Enhancements:**

*   **`check-s3-buckets.sh`**:
    *   Allow specifying an AWS region or iterating through all regions.
    *   Provide an option for selective checks (e.g., only public access status).
    *   Offer JSON output in addition to CSV.
    *   Implement more granular public access analysis (e.g., checking Block Public Access settings).
    *   Enhance logging capabilities.
*   **`list-manage-vpc-all-regions.sh`**:
    *   Offer JSON or CSV output formats.
    *   Provide an option to retrieve and display more detailed VPC information (e.g., CIDR blocks, tags, default VPC status).
    *   Allow filtering of VPCs based on tags or other criteria.
*   **`save-route53-records.sh`**:
    *   Support providing multiple domain names (e.g., comma-separated or from a file).
    *   Allow specifying an output directory for the CSV file.
    *   Allow providing the Route53 Hosted Zone ID directly as an alternative to the domain name.
    *   Add an option to filter records by type (e.g., A, CNAME, MX).

Feel free to fork the repository, make improvements, and submit a pull request!
