/******************************************************************************
Input Variables
******************************************************************************/

variable "region" {
  description = "AWS region in which to launch all AWS resources"
  default     = "ca-central-1"
}

variable "state_bucket_name" {
  description = "Name of Terraform state bucket"
  default     = "cace1-tf-orthos-test"
}
