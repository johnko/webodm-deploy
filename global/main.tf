/******************************************************************************
Provider
******************************************************************************/

provider "aws" {
  region = "${var.region}"
}

/******************************************************************************
Terraform Remote State and Locking
******************************************************************************/

terraform {
  backend "s3" {
    bucket  = "orthos-test-terraform"    # ${var.state_bucket_name}
    key     = "global/terraform.tfstate"
    encrypt = true
    acl     = "private"

    # dynamodb_table = "terraform_locks"

    # Store global in ca-central-1 only (don't assume region)
    region = "ca-central-1"
  }
}
