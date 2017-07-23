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
    region         = "ca-central-1"             # ${var.region}
    bucket         = "cace1-tf-marc-orthos"     # ${var.state_bucket_name}
    key            = "global/terraform.tfstate"
    encrypt        = true
    acl            = "private"
    dynamodb_table = "terraform_lock"
  }
}