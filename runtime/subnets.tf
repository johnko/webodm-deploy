/******************************************************************************
Public Subnets
******************************************************************************/

resource "aws_subnet" "public_0" {
  vpc_id                  = "${aws_vpc.main.id}"
  cidr_block              = "${cidrsubnet(var.vpc_cidr_block, 6, 0)}"
  availability_zone       = "${data.aws_availability_zones.azs.names[0]}"
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.basename}_pub_sub_0"
  }
}

/******************************************************************************
Create Public Internet Gateway and Route
******************************************************************************/

resource "aws_internet_gateway" "public" {
  vpc_id = "${aws_vpc.main.id}"

  tags = {
    Name = "${var.basename}_pub_igw"
  }
}

resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.main.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.public.id}"
  }

  tags = {
    Name = "${var.basename}_pub_rtb"
  }
}

resource "aws_route_table_association" "public_0" {
  route_table_id = "${aws_route_table.public.id}"
  subnet_id      = "${aws_subnet.public_0.id}"
}
