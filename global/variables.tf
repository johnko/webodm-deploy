/******************************************************************************

******************************************************************************/

variable "region" {
  description = "AWS region in which to launch all AWS resources"
  default     = "ca-central-1"
}

variable "state_bucket_name" {
  description = "Bucket name to store Terraform state payloads"
  default     = "orthos-test-terraform"
}
