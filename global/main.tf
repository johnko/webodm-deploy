/******************************************************************************
Provider
******************************************************************************/

provider "aws" {
  region = "${var.region}"
}

/******************************************************************************
S3 Bucket for Terraform State Payloads
******************************************************************************/

resource "aws_s3_bucket" "state" {
  bucket        = "${var.state_bucket_name}"
  acl           = "private"
  force_destroy = false
  region        = "${var.region}"

  versioning {
    enabled = true
  }
}

resource "aws_s3_bucket_policy" "state" {
  bucket = "${aws_s3_bucket.state.id}"

  policy = <<POLICYEOF
{
  "Id": "PutObjPolicy",
  "Statement": [
    {
      "Action": "s3:PutObject",
      "Condition": {
        "StringNotEquals": {
          "s3:x-amz-server-side-encryption": "AES256"
        }
      },
      "Effect": "Deny",
      "Principal": "*",
      "Resource": "arn:aws:s3:::${var.state_bucket_name}/*",
      "Sid": "DenyIncorrectEncryptionHeader"
    },
    {
      "Action": "s3:PutObject",
      "Condition": {
        "Null": {
          "s3:x-amz-server-side-encryption": "true"
        }
      },
      "Effect": "Deny",
      "Principal": "*",
      "Resource": "arn:aws:s3:::${var.state_bucket_name}/*",
      "Sid": "DenyUnEncryptedObjectUploads"
    }
  ],
  "Version": "2012-10-17"
}
POLICYEOF
}

/******************************************************************************
Terraform State and Locking
******************************************************************************/

terraform {
  backend "s3" {
    bucket  = "orthos-test-terraform"
    key     = "global/terraform.tfstate"
    region  = "ca-central-1"
    encrypt = true

    # dynamodb_table = foo
  }
}