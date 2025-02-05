This repository contains the Terraform configuration for my homelab, which includes infrastructure on AWS and DNS configuration on Cloudflare. The configuration is used to manage the remote state of Terraform in an S3 bucket, encrypt secrets with a KMS key, and lock access to the state using a DynamoDB table.

Repository Contents:

    Terraform configuration to create an S3 bucket on AWS for remote state
    Terraform configuration to create a KMS key on AWS to encrypt the secrets
    Terraform configuration to create a DynamoDB table on AWS to lock access to the state
    Terraform configuration to create DNS records on Cloudflare

Prerequisites:

    AWS account with administrator permissions
    Cloudflare account with administrator permissions
    Terraform installed on your local machine

Usage:

    Clone this repository to your local machine
    Create a ‘secrets’ folder to include the files aws.yml and cloudflare.yml.
    Run terragrunt init to initialize the Terraform state
    Run terragrunt apply to apply the configuration

Notes:

    Make sure you have the necessary permissions to create resources on AWS and Cloudflare
    Make sure you have Terraform and Terragrunt installed on your local machine
    This repository is for example purposes only and should not be used in production without modifications

