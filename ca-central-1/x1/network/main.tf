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
    region         = "ca-central-1"                 # ${var.region}
    bucket         = "cace1-tf-marc-orthos"         # ${var.state_bucket_name}
    key            = "x1/network/terraform.tfstate"
    encrypt        = true
    acl            = "private"
    dynamodb_table = "terraform_lock"
  }
}

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
    Managed_By  = "${var.managed_by}"
  }
}

# Just tag the default rtb

resource "aws_default_route_table" "default" {
  default_route_table_id = "${aws_vpc.main.default_route_table_id}"

  tags = {
    Name        = "vpc-${var.basename}-rtb-def"
    Environment = "${var.environment}"
    Managed_By  = "${var.managed_by}"
  }
}

# Just tag the default acl but also replace the rules that got cleared out
# automatically

resource "aws_default_network_acl" "default" {
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
    Name        = "vpc-${var.basename}-acl-def"
    Environment = "${var.environment}"
    Managed_By  = "${var.managed_by}"
  }
}

# Just tag the default sg but also replace the rules that got cleared out
# automatically

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
    Name        = "vpc-${var.basename}-sg-def"
    Environment = "${var.environment}"
    Managed_By  = "${var.managed_by}"
  }
}

/******************************************************************************
DHCP Options Set
******************************************************************************/

resource "aws_vpc_dhcp_options" "domain_name" {
  domain_name         = "${var.region}.compute.internal"
  domain_name_servers = ["AmazonProvidedDNS"]

  tags = {
    Name        = "vpc-${var.basename}-dopt"
    Environment = "${var.environment}"
    Managed_By  = "${var.managed_by}"
  }
}

resource "aws_vpc_dhcp_options_association" "domain_name" {
  vpc_id          = "${aws_vpc.main.id}"
  dhcp_options_id = "${aws_vpc_dhcp_options.domain_name.id}"
}

/******************************************************************************
Availability Zones
******************************************************************************/

data "aws_availability_zones" "all" {}

/******************************************************************************
Public Subnets
******************************************************************************/

resource "aws_subnet" "public_az0" {
  vpc_id                  = "${aws_vpc.main.id}"
  cidr_block              = "${cidrsubnet(var.vpc_cidr_block, 6, 0)}"
  availability_zone       = "${data.aws_availability_zones.all.names[0]}"
  map_public_ip_on_launch = true

  tags = {
    Name        = "vpc-${var.basename}-sub-az0-pub"
    Environment = "${var.environment}"
    Managed_By  = "${var.managed_by}"
  }
}

resource "aws_subnet" "public_az1" {
  vpc_id                  = "${aws_vpc.main.id}"
  cidr_block              = "${cidrsubnet(var.vpc_cidr_block, 6, 1)}"
  availability_zone       = "${data.aws_availability_zones.all.names[1]}"
  map_public_ip_on_launch = true

  tags = {
    Name        = "vpc-${var.basename}-sub-az1-pub"
    Environment = "${var.environment}"
    Managed_By  = "${var.managed_by}"
  }
}

/******************************************************************************
Protected Subnets
******************************************************************************/

resource "aws_subnet" "protected_az0" {
  vpc_id                  = "${aws_vpc.main.id}"
  cidr_block              = "${cidrsubnet(var.vpc_cidr_block, 6, 2)}"
  availability_zone       = "${data.aws_availability_zones.all.names[0]}"
  map_public_ip_on_launch = false

  tags = {
    Name        = "vpc-${var.basename}-sub-az0-prot"
    Environment = "${var.environment}"
    Managed_By  = "${var.managed_by}"
  }
}

resource "aws_subnet" "protected_az1" {
  vpc_id                  = "${aws_vpc.main.id}"
  cidr_block              = "${cidrsubnet(var.vpc_cidr_block, 6, 3)}"
  availability_zone       = "${data.aws_availability_zones.all.names[1]}"
  map_public_ip_on_launch = false

  tags = {
    Name        = "vpc-${var.basename}-sub-az1-prot"
    Environment = "${var.environment}"
    Managed_By  = "${var.managed_by}"
  }
}

/******************************************************************************
Private Subnets
******************************************************************************/

resource "aws_subnet" "private_az0" {
  vpc_id                  = "${aws_vpc.main.id}"
  cidr_block              = "${cidrsubnet(var.vpc_cidr_block, 6, 4)}"
  availability_zone       = "${data.aws_availability_zones.all.names[0]}"
  map_public_ip_on_launch = false

  tags = {
    Name        = "vpc-${var.basename}-sub-az0-priv"
    Environment = "${var.environment}"
    Managed_By  = "${var.managed_by}"
  }
}

resource "aws_subnet" "private_az1" {
  vpc_id                  = "${aws_vpc.main.id}"
  cidr_block              = "${cidrsubnet(var.vpc_cidr_block, 6, 5)}"
  availability_zone       = "${data.aws_availability_zones.all.names[1]}"
  map_public_ip_on_launch = false

  tags = {
    Name        = "vpc-${var.basename}-sub-az1-priv"
    Environment = "${var.environment}"
    Managed_By  = "${var.managed_by}"
  }
}

/******************************************************************************
GWs and EIPs
******************************************************************************/

resource "aws_internet_gateway" "public" {
  vpc_id = "${aws_vpc.main.id}"

  tags = {
    Name        = "vpc-${var.basename}-igw"
    Environment = "${var.environment}"
    Managed_By  = "${var.managed_by}"
  }
}

/*
resource "aws_eip" "az0" {
  vpc        = true
  depends_on = ["aws_internet_gateway.public"]
}

resource "aws_eip" "az1" {
  vpc        = true
  depends_on = ["aws_internet_gateway.public"]
}

resource "aws_nat_gateway" "az0" {
  allocation_id = "${aws_eip.az0.id}"
  subnet_id     = "${aws_subnet.public_az0.id}"
  depends_on    = ["aws_internet_gateway.public"]
}

resource "aws_nat_gateway" "az1" {
  allocation_id = "${aws_eip.az1.id}"
  subnet_id     = "${aws_subnet.public_az1.id}"
  depends_on    = ["aws_internet_gateway.public"]
}
*/

resource "aws_egress_only_internet_gateway" "eigw" {
  vpc_id = "${aws_vpc.main.id}"
}

/******************************************************************************
Public Route Table
******************************************************************************/

resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.main.id}"

  tags = {
    Name        = "vpc-${var.basename}-rtb-pub"
    Environment = "${var.environment}"
    Managed_By  = "${var.managed_by}"
  }
}

resource "aws_route_table_association" "public_az0" {
  route_table_id = "${aws_route_table.public.id}"
  subnet_id      = "${aws_subnet.public_az0.id}"
}

resource "aws_route_table_association" "public_az1" {
  route_table_id = "${aws_route_table.public.id}"
  subnet_id      = "${aws_subnet.public_az1.id}"
}

resource "aws_route" "public_ipv4" {
  route_table_id         = "${aws_route_table.public.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.public.id}"
}

resource "aws_route" "public_ipv6" {
  route_table_id              = "${aws_route_table.public.id}"
  destination_ipv6_cidr_block = "::/0"
  gateway_id                  = "${aws_internet_gateway.public.id}"
}

/******************************************************************************
Protected Route Tables
******************************************************************************/

resource "aws_route_table" "protected_az0" {
  vpc_id = "${aws_vpc.main.id}"

  tags = {
    Name        = "vpc-${var.basename}-rtb-az0-prot"
    Environment = "${var.environment}"
    Managed_By  = "${var.managed_by}"
  }
}

resource "aws_route_table" "protected_az1" {
  vpc_id = "${aws_vpc.main.id}"

  tags = {
    Name        = "vpc-${var.basename}-rtb-az1-prot"
    Environment = "${var.environment}"
    Managed_By  = "${var.managed_by}"
  }
}

resource "aws_route_table_association" "protected_az0" {
  route_table_id = "${aws_route_table.protected_az0.id}"
  subnet_id      = "${aws_subnet.protected_az0.id}"
}

resource "aws_route_table_association" "protected_az1" {
  route_table_id = "${aws_route_table.protected_az1.id}"
  subnet_id      = "${aws_subnet.protected_az1.id}"
}

/*
resource "aws_route" "protected_az0_ipv4" {
  route_table_id         = "${aws_route_table.protected_az0.id}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = "${aws_nat_gateway.az0.id}"
}
*/

resource "aws_route" "protected_az0_ipv6" {
  route_table_id              = "${aws_route_table.protected_az0.id}"
  destination_ipv6_cidr_block = "::/0"
  egress_only_gateway_id      = "${aws_egress_only_internet_gateway.eigw.id}"
}

/*
resource "aws_route" "protected_az1_ipv4" {
  route_table_id         = "${aws_route_table.protected_az1.id}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = "${aws_nat_gateway.az1.id}"
}
*/

resource "aws_route" "protected_az1_ipv6" {
  route_table_id              = "${aws_route_table.protected_az1.id}"
  destination_ipv6_cidr_block = "::/0"
  egress_only_gateway_id      = "${aws_egress_only_internet_gateway.eigw.id}"
}

/******************************************************************************
Private Route Tables
******************************************************************************/

resource "aws_route_table" "private_az0" {
  vpc_id = "${aws_vpc.main.id}"

  tags = {
    Name        = "vpc-${var.basename}-rtb-az0-priv"
    Environment = "${var.environment}"
    Managed_By  = "${var.managed_by}"
  }
}

resource "aws_route_table" "private_az1" {
  vpc_id = "${aws_vpc.main.id}"

  tags = {
    Name        = "vpc-${var.basename}-rtb-az1-priv"
    Environment = "${var.environment}"
    Managed_By  = "${var.managed_by}"
  }
}

resource "aws_route_table_association" "private_az0" {
  route_table_id = "${aws_route_table.private_az0.id}"
  subnet_id      = "${aws_subnet.private_az0.id}"
}

resource "aws_route_table_association" "private_az1" {
  route_table_id = "${aws_route_table.private_az1.id}"
  subnet_id      = "${aws_subnet.private_az1.id}"
}

/*
resource "aws_route" "private_az0_ipv4" {
  route_table_id         = "${aws_route_table.private_az0.id}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = "${aws_nat_gateway.az0.id}"
}
*/

resource "aws_route" "private_az0_ipv6" {
  route_table_id              = "${aws_route_table.private_az0.id}"
  destination_ipv6_cidr_block = "::/0"
  egress_only_gateway_id      = "${aws_egress_only_internet_gateway.eigw.id}"
}

/*
resource "aws_route" "private_az1_ipv4" {
  route_table_id         = "${aws_route_table.private_az1.id}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = "${aws_nat_gateway.az1.id}"
}
*/

resource "aws_route" "private_az1_ipv6" {
  route_table_id              = "${aws_route_table.private_az1.id}"
  destination_ipv6_cidr_block = "::/0"
  egress_only_gateway_id      = "${aws_egress_only_internet_gateway.eigw.id}"
}

# XXX FIXME XXX Add descriptions to all security groups???

# https://blog.threatstack.com/incorporating-aws-security-best-practices-into-terraform-design
# https://aws.amazon.com/blogs/aws/building-three-tier-architectures-with-security-groups/

/******************************************************************************
Public Security Group
******************************************************************************/

resource "aws_security_group" "public" {
  vpc_id = "${aws_vpc.main.id}"
  name   = "vpc-${var.basename}-sg-pub"

  tags = {
    Name        = "vpc-${var.basename}-sg-pub"
    Environment = "${var.environment}"
    Managed_By  = "${var.managed_by}"
  }
}

resource "aws_security_group_rule" "ingress_public" {
  security_group_id = "${aws_security_group.public.id}"
  type              = "ingress"
  from_port         = "0"
  to_port           = "0"
  protocol          = "-1"
  self              = true
}

resource "aws_security_group_rule" "ingress_public_ssh_ipv4" {
  security_group_id = "${aws_security_group.public.id}"
  type              = "ingress"
  from_port         = "22"
  to_port           = "22"
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "ingress_public_ssh_ipv6" {
  security_group_id = "${aws_security_group.public.id}"
  type              = "ingress"
  from_port         = "22"
  to_port           = "22"
  protocol          = "tcp"
  ipv6_cidr_blocks  = ["::/0"]
}

resource "aws_security_group_rule" "egress_public_ipv4" {
  security_group_id = "${aws_security_group.public.id}"
  type              = "egress"
  from_port         = "0"
  to_port           = "0"
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "egress_public_ipv6" {
  security_group_id = "${aws_security_group.public.id}"
  type              = "egress"
  from_port         = "0"
  to_port           = "0"
  protocol          = "-1"
  ipv6_cidr_blocks  = ["::/0"]
}

/******************************************************************************
Protected Security Group
******************************************************************************/

resource "aws_security_group" "protected" {
  vpc_id = "${aws_vpc.main.id}"
  name   = "vpc-${var.basename}-sg-prot"

  tags = {
    Name        = "vpc-${var.basename}-sg-prot"
    Environment = "${var.environment}"
    Managed_By  = "${var.managed_by}"
  }
}

resource "aws_security_group_rule" "ingress_protected" {
  security_group_id        = "${aws_security_group.protected.id}"
  type                     = "ingress"
  from_port                = "0"
  to_port                  = "0"
  protocol                 = "-1"
  source_security_group_id = "${aws_security_group.public.id}"
}

resource "aws_security_group_rule" "egress_protected_ipv4" {
  security_group_id = "${aws_security_group.protected.id}"
  type              = "egress"
  from_port         = "0"
  to_port           = "0"
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "egress_protected_ipv6" {
  security_group_id = "${aws_security_group.protected.id}"
  type              = "egress"
  from_port         = "0"
  to_port           = "0"
  protocol          = "-1"
  ipv6_cidr_blocks  = ["::/0"]
}

/******************************************************************************
Private Security Group
******************************************************************************/

resource "aws_security_group" "private" {
  vpc_id = "${aws_vpc.main.id}"
  name   = "vpc-${var.basename}-sg-priv"

  tags = {
    Name        = "vpc-${var.basename}-sg-priv"
    Environment = "${var.environment}"
    Managed_By  = "${var.managed_by}"
  }
}

resource "aws_security_group_rule" "ingress_private" {
  security_group_id        = "${aws_security_group.private.id}"
  type                     = "ingress"
  from_port                = "0"
  to_port                  = "0"
  protocol                 = "-1"
  source_security_group_id = "${aws_security_group.protected.id}"
}

resource "aws_security_group_rule" "egress_private_ipv4" {
  security_group_id = "${aws_security_group.private.id}"
  type              = "egress"
  from_port         = "0"
  to_port           = "0"
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "egress_private_ipv6" {
  security_group_id = "${aws_security_group.private.id}"
  type              = "egress"
  from_port         = "0"
  to_port           = "0"
  protocol          = "-1"
  ipv6_cidr_blocks  = ["::/0"]
}

/******************************************************************************
SSH Bastion Hosts
******************************************************************************/

# XXX FIXME XXX Put these behind ASGs???

/*
resource "aws_instance" "public_bastion_az0" {
  instance_type          = "t2.micro"
  ami                    = "${lookup(var.bastion_amis, var.region)}"
  availability_zone      = "${data.aws_availability_zones.all.names[0]}"
  subnet_id              = "${aws_subnet.public_az0.id}"
  vpc_security_group_ids = ["${aws_security_group.public.id}"]
  user_data              = "${file("bastion_keys.sh")}"

  connection {
    user = "admin"
  }

  tags = {
    Name        = "vpc-${var.basename}-bast-az0-pub"
    Environment = "${var.environment}"
    Managed_By  = "${var.managed_by}"
  }
}

resource "aws_instance" "public_bastion_az1" {
  instance_type          = "t2.micro"
  ami                    = "${lookup(var.bastion_amis, var.region)}"
  availability_zone      = "${data.aws_availability_zones.all.names[1]}"
  subnet_id              = "${aws_subnet.public_az1.id}"
  vpc_security_group_ids = ["${aws_security_group.public.id}"]
  user_data              = "${file("bastion_keys.sh")}"

  connection {
    user = "admin"
  }

  tags = {
    Name        = "vpc-${var.basename}-bast-az1-pub"
    Environment = "${var.environment}"
    Managed_By  = "${var.managed_by}"
  }
}

resource "aws_instance" "protected_bastion_az0" {
  instance_type          = "t2.micro"
  ami                    = "${lookup(var.bastion_amis, var.region)}"
  availability_zone      = "${data.aws_availability_zones.all.names[0]}"
  subnet_id              = "${aws_subnet.protected_az0.id}"
  vpc_security_group_ids = ["${aws_security_group.protected.id}"]
  user_data              = "${file("bastion_keys.sh")}"

  connection {
    user = "admin"
  }

  tags = {
    Name        = "vpc-${var.basename}-bast-az0-prot"
    Environment = "${var.environment}"
    Managed_By  = "${var.managed_by}"
  }
}

resource "aws_instance" "protected_bastion_az1" {
  instance_type          = "t2.micro"
  ami                    = "${lookup(var.bastion_amis, var.region)}"
  availability_zone      = "${data.aws_availability_zones.all.names[1]}"
  subnet_id              = "${aws_subnet.protected_az1.id}"
  vpc_security_group_ids = ["${aws_security_group.protected.id}"]
  user_data              = "${file("bastion_keys.sh")}"

  connection {
    user = "admin"
  }

  tags = {
    Name        = "vpc-${var.basename}-bast-az1-prot"
    Environment = "${var.environment}"
    Managed_By  = "${var.managed_by}"
  }
}
*/
