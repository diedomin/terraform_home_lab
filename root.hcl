locals {
  aws_region                  = "eu-west-3"
  s3_tfstate_bucket_name      = yamldecode(sops_decrypt_file("${get_parent_terragrunt_dir()}/secrets/aws.yml"))["s3_tfstate_bucket_name"]
  env                         = "lab"
  dynamodb_tfstate_table_name = "terraform-state-lock"
}

terraform {
  before_hook "terraform_validate" {
    commands     = ["plan", "apply"]
    execute      = ["terraform", "validate"]
    run_on_error = true
  }
}

remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite"
  }

  config = {
    profile = "default"
    bucket  = local.s3_tfstate_bucket_name
    region  = local.aws_region
    encrypt = true
    skip_bucket_versioning = false
    dynamodb_table = local.dynamodb_tfstate_table_name
    key = "terraform/terraform.tfstate"
  }
}
