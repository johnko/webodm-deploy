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
    bucket         = "cace1-tf-orthos-test"               # ${var.state_bucket_name}
    key            = "test/application/terraform.tfstate"
    region         = "ca-central-1"                       # ${var.region}
    encrypt        = true
    acl            = "private"
    dynamodb_table = "terraform_lock"
  }
}

data "terraform_remote_state" "network" {
  backend = "s3"

  config {
    bucket = "cace1-tf-orthos-test"           # ${var.state_bucket_name}
    key    = "test/network/terraform.tfstate"
    region = "ca-central-1"                   # ${var.region}
  }
}
