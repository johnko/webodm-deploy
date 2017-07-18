/******************************************************************************
VPC
******************************************************************************/

# /16 for VPC, /20 for subnets --> 64 subnets of 1024 hosts each

resource "aws_vpc" "main" {
  cidr_block                       = "${var.vpc_cidr_block}"
  assign_generated_ipv6_cidr_block = true
  instance_tenancy                 = "default"
  enable_dns_hostnames             = true
  enable_dns_support               = true

  tags = {
    Name        = "vpc-${var.basename}"
    Environment = "${var.environment}"
    Managed_By  = "terraform"
  }
}

/******************************************************************************
Tag Auto-Generated Default Route Table
******************************************************************************/

resource "aws_default_route_table" "default_rtb" {
  default_route_table_id = "${aws_vpc.main.default_route_table_id}"

  tags = {
    Name        = "rtb-def-${var.basename}"
    Environment = "${var.environment}"
    Managed_By  = "terraform"
  }
}

/******************************************************************************
Tag Auto-Generated Default Network ACL
******************************************************************************/

# Just tag it but also replace the rules that got cleared out automatically

resource "aws_default_network_acl" "default_acl" {
  default_network_acl_id = "${aws_vpc.main.default_network_acl_id}"

  ingress {
    from_port  = 0
    to_port    = 0
    protocol   = -1
    cidr_block = "0.0.0.0/0"
    rule_no    = 100
    action     = "allow"
  }

  /* XXX FIXME XXX Re-enable after Terraform 0.10.0
  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = -1
    ipv6_cidr_block = "::/0"
    rule_no         = 101
    action          = "allow"
  }
  */

  egress {
    from_port  = 0
    to_port    = 0
    protocol   = -1
    cidr_block = "0.0.0.0/0"
    rule_no    = 100
    action     = "allow"
  }

  /* XXX FIXME XXX Re-enable after Terraform 0.10.0
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = -1
    ipv6_cidr_block = "::/0"
    rule_no         = 101
    action          = "allow"
  }
  */

  tags = {
    Name        = "acl-def-${var.basename}"
    Environment = "${var.environment}"
    Managed_By  = "terraform"
  }
}

/******************************************************************************
Tag Auto-Generated Default Security Group
******************************************************************************/

# Just tag it but also replace the rules that got cleared out automatically

resource "aws_default_security_group" "default" {
  vpc_id = "${aws_vpc.main.id}"

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = -1
    self      = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name        = "sg-def-${var.basename}"
    Environment = "${var.environment}"
    Managed_By  = "terraform"
  }
}

/******************************************************************************
DHCP Options Set
******************************************************************************/

resource "aws_vpc_dhcp_options" "domain_name" {
  domain_name         = "${var.region}.compute.internal"
  domain_name_servers = ["AmazonProvidedDNS"]

  tags = {
    Name        = "dopt-${var.basename}"
    Environment = "${var.environment}"
    Managed_By  = "terraform"
  }
}

resource "aws_vpc_dhcp_options_association" "domain_name" {
  vpc_id          = "${aws_vpc.main.id}"
  dhcp_options_id = "${aws_vpc_dhcp_options.domain_name.id}"
}
