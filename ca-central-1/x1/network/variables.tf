/******************************************************************************
Input Variables
******************************************************************************/

variable "region" {
  description = "AWS region in which to launch all AWS resources"
  default     = "ca-central-1"
}

variable "state_bucket_name" {
  description = "Name of Terraform state bucket"
  default     = "cace1-tf-marc-orthos"
}

variable "vpc_cidr_block" {
  description = "IPv4 CIDR block for the VPC"
  default     = "10.200.0.0/16"
}

variable "basename" {
  description = "Basename tag value to use for all AWS resources"
  default     = "x1"
}

variable "environment" {
  description = "Environment tag value to use for all AWS resources"
  default     = "development"
}

variable "managed_by" {
  description = "Managed_By tag value to use for all AWS resources"
  default     = "terraform"
}

# Instances must be:  Linux, amd64, hvm, ebs, ssd, gp2
# Current ones are Debian FAI images

variable "bastion_amis" {
  default = {
    ca-central-1 = "ami-aad36cce"
  }
}

variable "amis" {
  default = {
    ca-central-1 = "ami-aad36cce"
  }
}

variable "key_name" {
  description = "Desired name of AWS key pair"
  default     = "terraform"
}

# variable "public_key_path" {
#   description = <<DESCRIPTION
# Path to the SSH public key to be used for authentication.
# Ensure this keypair is added to your local SSH agent so provisioners can
# connect.
# Example: ~/.ssh/terraform.pub
# DESCRIPTION
# }

