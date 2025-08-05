# Terraform Home Lab Infrastructure

This repository contains the infrastructure as code configuration for my homelab setup, managed using **Terragrunt** as a wrapper around **OpenTofu/Terraform**. The configuration includes AWS infrastructure for state management and Cloudflare DNS management for homelab services.

## Architecture Overview

The project uses Terragrunt to provide:
- **DRY (Don't Repeat Yourself)** configuration with shared variables in `root.hcl`
- **Remote state management** with S3 backend and DynamoDB locking
- **Modular infrastructure** with separate AWS and Cloudflare components
- **Encrypted secrets management** using Mozilla SOPS

## Repository Structure

```
├── root.hcl                    # Common Terragrunt configuration
├── aws/
│   └── terragrunt.hcl         # AWS infrastructure deployment
├── cloudflare/
│   └── terragrunt.hcl         # Cloudflare DNS management
├── modules/
│   ├── aws/                   # AWS Terraform modules
│   │   ├── s3.tf             # S3 bucket for remote state
│   │   ├── kms.tf            # KMS key for encryption
│   │   ├── dynamodb.tf       # DynamoDB table for state locking
│   │   └── ...
│   └── cloudflare/           # Cloudflare Terraform modules
│       ├── main.tf           # DNS records configuration
│       └── ...
└── secrets/                  # SOPS encrypted secrets
    ├── aws.yml
    └── cloudflare.yml
```

## Infrastructure Components

### AWS Resources
- **S3 Bucket**: Remote state storage with versioning and encryption
- **KMS Key**: Encryption key for securing sensitive data
- **DynamoDB Table**: State locking to prevent concurrent modifications

### Cloudflare DNS
- **Base Domain Configuration**: MX, SPF, and DMARC records
- **Service Records**: DNS entries for homelab services (Grafana, Nextcloud, etc.)
- **Instance Records**: A records for physical homelab machines

## Prerequisites

- **OpenTofu** or **Terraform** (>= 1.0)
- **Terragrunt** (>= 0.45.0)
- **Mozilla SOPS** for secret encryption
- **AWS CLI** configured with appropriate credentials
- **Cloudflare API Token** with DNS management permissions

### Installation

```bash
# Install OpenTofu (recommended over Terraform)
# See: https://opentofu.org/docs/intro/install/

# Install Terragrunt
# See: https://terragrunt.gruntwork.io/docs/getting-started/install/

# Install SOPS
# See: https://github.com/mozilla/sops
```

## Usage

### 1. Initial Setup

```bash
# Clone the repository
git clone <repository-url>
cd terraform_home_lab

# Create and encrypt secrets files
mkdir -p secrets/
# Edit secrets/aws.yml and secrets/cloudflare.yml with your values
# Then encrypt them with SOPS
sops -e -i secrets/aws.yml
sops -e -i secrets/cloudflare.yml
```

### 2. Deploy AWS Infrastructure (First Time)

```bash
cd aws/
terragrunt init
terragrunt plan
terragrunt apply
```

### 3. Deploy Cloudflare DNS

```bash
cd ../cloudflare/
terragrunt init
terragrunt plan
terragrunt apply
```

### 4. Subsequent Updates

```bash
# Update any module
cd <aws|cloudflare>/
terragrunt plan
terragrunt apply
```

## Why Terragrunt over Plain OpenTofu/Terraform?

This project leverages **Terragrunt** as a wrapper around **OpenTofu** for several key benefits:

### 1. **DRY Configuration**
- Shared variables and configuration in `root.hcl`
- No need to duplicate backend configuration across modules
- Consistent naming and tagging across all resources

### 2. **Enhanced Remote State Management**
- Automatic backend generation with proper S3 configuration
- Environment-specific state file organization
- Built-in state locking with DynamoDB

### 3. **Simplified Multi-Environment Management**
- Easy to extend for dev/staging/prod environments
- Consistent deployment patterns across environments
- Reduced configuration drift

### 4. **Advanced Features**
- Built-in hooks for validation (see `root.hcl:10-15`)
- Dependency management between modules
- Before/after hooks for custom validation and cleanup

## Configuration Management

### Secret Management
Secrets are managed using Mozilla SOPS and stored in encrypted YAML files:
- `secrets/aws.yml`: Contains S3 bucket name and AWS-specific secrets
- `secrets/cloudflare.yml`: Contains Cloudflare API tokens and zone information

### DNS Records Structure
The Cloudflare module manages three types of DNS records:
- **Base records**: MX, SPF, DMARC for email configuration
- **Service records**: CNAME records for homelab services
- **Instance records**: A records for physical machines

## Important Notes

- **Security**: All secrets are encrypted using SOPS - never commit unencrypted secrets
- **State Management**: The S3 bucket and DynamoDB table must be created before other resources
- **Permissions**: Ensure AWS and Cloudflare credentials have sufficient permissions
- **Environment**: This configuration is designed for homelab use - review and modify for production environments

## Troubleshooting

### Common Issues

1. **SOPS Decryption Errors**: Ensure your GPG/KMS keys are properly configured
2. **State Lock Issues**: Check DynamoDB table permissions and connectivity
3. **DNS Propagation**: Cloudflare changes may take time to propagate

### Useful Commands

```bash
# Check Terragrunt configuration
terragrunt validate-inputs

# Show planned changes across all modules
terragrunt run-all plan

# Apply changes to all modules
terragrunt run-all apply

# Clean up generated files
terragrunt run-all clean
```

