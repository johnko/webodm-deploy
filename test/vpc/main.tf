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
    bucket  = "cace1-tf-test"              # ${var.state_bucket_name}
    key     = "test/vpc/terraform.tfstate"
    region  = "ca-central-1"               # ${var.region}
    encrypt = true
    acl     = "private"

    dynamodb_table = "terraform_lock"
  }
}
