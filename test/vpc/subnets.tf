/******************************************************************************
Availability Zones
******************************************************************************/

data "aws_availability_zones" "azs" {}

/******************************************************************************
Public Subnets
******************************************************************************/

resource "aws_subnet" "public_0" {
  vpc_id                  = "${aws_vpc.main.id}"
  cidr_block              = "${cidrsubnet(var.vpc_cidr_block, 6, 0)}"
  availability_zone       = "${data.aws_availability_zones.azs.names[0]}"
  map_public_ip_on_launch = true

  tags = {
    Name       = "${var.basename}_pub_sub_0"
    Managed_By = "terraform"
  }
}

resource "aws_subnet" "public_1" {
  vpc_id                  = "${aws_vpc.main.id}"
  cidr_block              = "${cidrsubnet(var.vpc_cidr_block, 6, 1)}"
  availability_zone       = "${data.aws_availability_zones.azs.names[1]}"
  map_public_ip_on_launch = true

  tags = {
    Name       = "${var.basename}_pub_sub_1"
    Managed_By = "terraform"
  }
}

/******************************************************************************
Private Subnets
******************************************************************************/

/* XXX FIXME XXX Temporarily disabled
resource "aws_subnet" "private_0" {
  vpc_id                  = "${aws_vpc.main.id}"
  cidr_block              = "${cidrsubnet(var.vpc_cidr_block, 6, 2)}"
  availability_zone       = "${data.aws_availability_zones.azs.names[0]}"
  map_public_ip_on_launch = false

  tags = {
    Name        = "${var.basename}_priv_sub_0"
    Managed_By  = "terraform"
  }
}

resource "aws_subnet" "private_1" {
  vpc_id                  = "${aws_vpc.main.id}"
  cidr_block              = "${cidrsubnet(var.vpc_cidr_block, 6, 3)}"
  availability_zone       = "${data.aws_availability_zones.azs.names[1]}"
  map_public_ip_on_launch = false

  tags = {
    Name        = "${var.basename}_priv_sub_1"
    Managed_By  = "terraform"
  }
}
*/

/******************************************************************************
Public Internet GW and Route Table
******************************************************************************/

resource "aws_internet_gateway" "public" {
  vpc_id = "${aws_vpc.main.id}"

  tags = {
    Name       = "${var.basename}_pub_igw"
    Managed_By = "terraform"
  }
}

resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.main.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.public.id}"
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = "${aws_internet_gateway.public.id}"
  }

  tags = {
    Name       = "${var.basename}_pub_rtb"
    Managed_By = "terraform"
  }
}

resource "aws_route_table_association" "public_0" {
  route_table_id = "${aws_route_table.public.id}"
  subnet_id      = "${aws_subnet.public_0.id}"
}

resource "aws_route_table_association" "public_1" {
  route_table_id = "${aws_route_table.public.id}"
  subnet_id      = "${aws_subnet.public_1.id}"
}

/******************************************************************************
NAT GWs and EIPs for Private Networks
******************************************************************************/


/* XXX FIXME XXX Temporarily disabled
resource "aws_eip" "nat_0" {
  vpc        = true
  depends_on = ["aws_internet_gateway.public"]
}

resource "aws_eip" "nat_1" {
  vpc        = true
  depends_on = ["aws_internet_gateway.public"]
}

resource "aws_nat_gateway" "nat_0" {
  allocation_id = "${aws_eip.nat_0.id}"
  subnet_id     = "${aws_subnet.public_0.id}"
  depends_on    = ["aws_internet_gateway.public"]
}

resource "aws_nat_gateway" "nat_1" {
  allocation_id = "${aws_eip.nat_1.id}"
  subnet_id     = "${aws_subnet.public_1.id}"
  depends_on    = ["aws_internet_gateway.public"]
}
*/


/******************************************************************************
Egress-only GW and Private Route Tables
******************************************************************************/


# XXX FIXME XXX Convert route tables to routes???


/* XXX FIXME XXX Temporarily disabled
resource "aws_egress_only_internet_gateway" "eigw" {
  vpc_id = "${aws_vpc.main.id}"
}

resource "aws_route_table" "private_0" {
  vpc_id = "${aws_vpc.main.id}"

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.nat_0.id}"
  }

  route {
    ipv6_cidr_block        = "::/0"
    egress_only_gateway_id = "${aws_egress_only_internet_gateway.eigw.id}"
  }

  tags = {
    Name        = "${var.basename}_priv_rtb_0"
    Managed_By  = "terraform"
  }
}

resource "aws_route_table" "private_1" {
  vpc_id = "${aws_vpc.main.id}"

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.nat_1.id}"
  }

  route {
    ipv6_cidr_block        = "::/0"
    egress_only_gateway_id = "${aws_egress_only_internet_gateway.eigw.id}"
  }

  tags = {
    Name        = "${var.basename}_priv_rtb_1"
    Managed_By  = "terraform"
  }
}

resource "aws_route_table_association" "private_0" {
  route_table_id = "${aws_route_table.private_0.id}"
  subnet_id      = "${aws_subnet.private_0.id}"
}

resource "aws_route_table_association" "private_1" {
  route_table_id = "${aws_route_table.private_1.id}"
  subnet_id      = "${aws_subnet.private_1.id}"
}
*/

