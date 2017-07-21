/******************************************************************************
Output Variables
******************************************************************************/

output "vpc_id" {
  value = "${aws_vpc.main.id}"
}

output "availability_zones" {
  value = ["${data.aws_availability_zones.all.names}"]
}

output "public_subnets" {
  value = ["${aws_subnet.public_az0.id}", "${aws_subnet.public_az1.id}"]
}

output "protected_subnets" {
  value = ["${aws_subnet.protected_az0.id}", "${aws_subnet.protected_az1.id}"]
}

output "private_subnets" {
  value = ["${aws_subnet.private_az0.id}", "${aws_subnet.private_az1.id}"]
}
