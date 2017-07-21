# XXX FIXME XXX Continue fixing this junk
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
