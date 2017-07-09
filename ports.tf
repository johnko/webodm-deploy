# XXX FIXME XXX Make sure the tags, names, descriptions and resources
# all have sensible names

/******************************************************************************

******************************************************************************/

resource "aws_security_group" "ssh" {
  vpc_id      = "${aws_vpc.main.id}"
  name        = "ssh/scp"
  description = "Inbound SSH/SCP"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.basename}_sg_ssh_scp"
  }
}

/******************************************************************************

******************************************************************************/

resource "aws_security_group" "icmp" {
  vpc_id      = "${aws_vpc.main.id}"
  name        = "icmp"
  description = "Inbound ICMP"

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.basename}_sg_icmp"
  }
}

/******************************************************************************

******************************************************************************/

resource "aws_security_group" "http" {
  vpc_id      = "${aws_vpc.main.id}"
  name        = "http"
  description = "HTTP"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.basename}_sg_http"
  }
}

/******************************************************************************

******************************************************************************/

resource "aws_security_group" "http_alt" {
  vpc_id      = "${aws_vpc.main.id}"
  name        = "http alternate"
  description = "HTTP"

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.basename}_sg_http_alt"
  }
}

/******************************************************************************

******************************************************************************/

resource "aws_security_group" "https" {
  vpc_id      = "${aws_vpc.main.id}"
  name        = "https"
  description = "HTTPS"

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.basename}_sg_https"
  }
}
