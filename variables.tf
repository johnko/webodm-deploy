/******************************************************************************

******************************************************************************/

variable "basename" {
  description = "Base name to use in tags for all AWS resources"
  default     = "webodm"
}

variable "vpc_cidr_block" {
  description = "IPv4 CIDR block for the VPC"
  default     = "10.200.0.0/16"
}

variable "region" {
  description = "AWS region in which to launch all AWS resources"
  default     = "ca-central-1"
}

# Instance type must be Linux, amd64, hvm, ebs, ssd, gp2
# Current ones are Debian FAI images

variable "amis" {
  default = {
    ca-central-1 = "ami-aad36cce"
    us-east-1    = "ami-27072e31"
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
