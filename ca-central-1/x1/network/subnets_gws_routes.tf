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

resource "aws_route" "protected_az0_ipv6" {
  route_table_id              = "${aws_route_table.protected_az0.id}"
  destination_ipv6_cidr_block = "::/0"
  egress_only_gateway_id      = "${aws_egress_only_internet_gateway.eigw.id}"
}

/*
resource "aws_route" "protected_az0_ipv4" {
  route_table_id         = "${aws_route_table.protected_az0.id}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = "${aws_nat_gateway.az0.id}"
}
*/

resource "aws_route" "protected_az1_ipv6" {
  route_table_id              = "${aws_route_table.protected_az1.id}"
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

resource "aws_route" "private_az0_ipv6" {
  route_table_id              = "${aws_route_table.private_az0.id}"
  destination_ipv6_cidr_block = "::/0"
  egress_only_gateway_id      = "${aws_egress_only_internet_gateway.eigw.id}"
}

/*
resource "aws_route" "private_az0_ipv4" {
  route_table_id         = "${aws_route_table.private_az0.id}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = "${aws_nat_gateway.az0.id}"
}
*/

resource "aws_route" "private_az1_ipv6" {
  route_table_id              = "${aws_route_table.private_az1.id}"
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

