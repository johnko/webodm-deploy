/******************************************************************************
Provider
******************************************************************************/

provider "aws" {
  region = "${var.region}"
}

/******************************************************************************
Terraform State and Locking
******************************************************************************/

# NOTE:  If you change the bucket name, key or region here, you must update
# them in all the other terraform files as well.

terraform {
  backend "s3" {
    bucket  = "orthos-test-terraform"
    key     = "test/vpc/terraform.tfstate"
    region  = "ca-central-1"
    encrypt = true

    # XXX FIXME XXX Get state locking working next!!!
  }
}
