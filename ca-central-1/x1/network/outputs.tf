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

output "public_security_group" {
  value = "${aws_security_group.public.id}"
}

output "protected_security_group" {
  value = "${aws_security_group.protected.id}"
}

output "private_security_group" {
  value = "${aws_security_group.private.id}"
}

output "public_bastion_az0_ip" {
  value = "${aws_instance.public_bastion_az0.public_ip}"
}

output "public_bastion_az1_ip" {
  value = "${aws_instance.public_bastion_az1.public_ip}"
}

output "protected_bastion_az0_ip" {
  value = "${aws_instance.protected_bastion_az0.private_ip}"
}

output "protected_bastion_az1_ip" {
  value = "${aws_instance.protected_bastion_az1.private_ip}"
}
