/******************************************************************************
Provider
******************************************************************************/

provider "aws" {
  region = "${var.region}"
}

/******************************************************************************
Remote State and Locking
******************************************************************************/

terraform {
  backend "s3" {
    region         = "ca-central-1"                     # ${var.region}
    bucket         = "cace1-tf-marc-orthos"             # ${var.state_bucket_name}
    key            = "x1/application/terraform.tfstate"
    encrypt        = true
    acl            = "private"
    dynamodb_table = "terraform_lock"
  }
}

data "terraform_remote_state" "network" {
  backend = "s3"

  config {
    region = "ca-central-1"                 # ${var.region}
    bucket = "cace1-tf-marc-orthos"         # ${var.state_bucket_name}
    key    = "x1/network/terraform.tfstate"
  }
}
