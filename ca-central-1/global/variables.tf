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

variable "managed_by" {
  description = "Managed_By tag value to use for all AWS resources"
  default     = "terraform"
}

variable "basename" {
  description = "Basename tag value to use for all AWS resources"
  default     = "x1"
}

variable "environment" {
  description = "Environment tag value to use for all AWS resources"
  default     = "development"
}

variable "vpc_cidr_block" {
  description = "IPv4 CIDR block for the VPC"
  default     = "10.200.0.0/16"
}

variable "hosted_zone_id" {
  description = "Route53 Hosted Zone ID of the domain to update"
  default     = "XXXX"
}

# Instances must be:  Linux, amd64, hvm, ebs, ssd, gp2
# Current ones are Debian FAI images

variable "app_amis" {
  default = {
    ca-central-1 = "ami-aad36cce"
  }
}

variable "bastion_amis" {
  default = {
    ca-central-1 = "ami-aad36cce"
  }
}

variable "base_amis" {
  default = {
    ca-central-1 = "ami-aad36cce"
  }
}
