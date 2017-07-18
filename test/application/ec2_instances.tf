/******************************************************************************

******************************************************************************/
/*
resource "aws_key_pair" "deploy" {
  key_name   = "${var.key_name}"
  public_key = "${file(var.public_key_path)}"
}
resource "aws_instance" "web" {
  # The connection block tells our provisioner how to communicate with the
  # instance
  connection {
    # The default username for our AMI
    user = "admin"

    # The connection will use the local SSH agent for authentication.
  }

  instance_type = "t2.micro"

  ami = "${lookup(var.amis, var.region)}"

  # The name of our SSH keypair we created above.
  key_name = "${aws_key_pair.deploy.id}"

  # Our Security group to allow HTTP and SSH access
  vpc_security_group_ids = ["${aws_security_group.default.id}"]

  # We're going to launch into the same subnet as our ELB. In a production
  # environment it's more common to have a separate private subnet for
  # backend instances.
  subnet_id = "${aws_subnet.pub_a.id}"

  # We run a remote provisioner on the instance after creating it.
  # In this case, we just install nginx and start it. By default,
  # this should be on port 80
  provisioner "remote-exec" {
    inline = [
      "sudo apt-get --yes update",
      "sudo apt-get --yes install nginx",
      "sudo service nginx start",
    ]
  }
}
*/

