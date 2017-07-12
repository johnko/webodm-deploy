/******************************************************************************
SSH
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

  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    ipv6_cidr_blocks = ["::/0"]
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
    Name      = "${var.basename}_sg_ssh_scp"
    Terraform = true
  }
}

/******************************************************************************
ICMP (ping)
******************************************************************************/

resource "aws_security_group" "icmp" {
  vpc_id      = "${aws_vpc.main.id}"
  name        = "icmp"
  description = "Inbound ICMP"

  ingress {
    from_port   = 8
    to_port     = 0
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port        = 8
    to_port          = 0
    protocol         = "icmp"
    ipv6_cidr_blocks = ["::/0"]
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
    Name      = "${var.basename}_sg_icmp"
    Terraform = true
  }
}

/******************************************************************************
HTTP
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

  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    ipv6_cidr_blocks = ["::/0"]
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
    Name      = "${var.basename}_sg_http"
    Terraform = true
  }
}

/******************************************************************************
HTTP Alternate
******************************************************************************/

resource "aws_security_group" "http_alt" {
  vpc_id      = "${aws_vpc.main.id}"
  name        = "http alternate"
  description = "HTTP"

  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port        = 8000
    to_port          = 8000
    protocol         = "tcp"
    ipv6_cidr_blocks = ["::/0"]
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
    Name      = "${var.basename}_sg_http_alt"
    Terraform = true
  }
}

/******************************************************************************
HTTPS
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

  ingress {
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    ipv6_cidr_blocks = ["::/0"]
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
    Name      = "${var.basename}_sg_https"
    Terraform = true
  }
}

/******************************************************************************
Node Application
******************************************************************************/

resource "aws_security_group" "node_app" {
  vpc_id      = "${aws_vpc.main.id}"
  name        = "node_app"
  description = "Node Application"

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port        = 3000
    to_port          = 3000
    protocol         = "tcp"
    ipv6_cidr_blocks = ["::/0"]
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
    Name      = "${var.basename}_sg_node_app"
    Terraform = true
  }
}
