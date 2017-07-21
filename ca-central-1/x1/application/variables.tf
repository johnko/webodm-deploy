/******************************************************************************
Input Variables
******************************************************************************/

variable "region" {
  description = "AWS region in which to launch all AWS resources"
  default     = "ca-central-1"
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

variable "hosted_zone_id" {
  description = "Route53 Hosted Zone ID of the domain to update"
  default     = "XXXX"
}

# Instances must be:  Linux, amd64, hvm, ebs, ssd, gp2
# Current ones are Debian FAI images

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

