/******************************************************************************

******************************************************************************/

# IAM role --> "What can I do?"
# instance profile --> "Who am I?"

resource "aws_iam_role" "test_role" {
  name = "${var.basename}_role"
  description = "Terraform instance role"

  # XXX FIXME XXX Give this a nice path!!!
  # path = "/"

  assume_role_policy = <<EOF
{
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Sid": ""
    }
  ],
  "Version": "2012-10-17"
}
EOF
}

resource "aws_iam_instance_profile" "test_profile" {
  name = "${var.basename}_profile"
  role = "${aws_iam_role.test_role.name}"

  # XXX FIXME XXX Give this a nice path!!!
  # path = "/"
}

resource "aws_iam_role_policy" "test_policy" {
  name = "${var.basename}_policy"
  role = "${aws_iam_role.test_role.id}"

  policy = <<EOF
{
  "Statement": [
    {
      "Action": [
        "s3:ListBucket"
      ],
      "Effect": "Allow",
      "Resource": ["arn:aws:s3:::webodm-test"]
    },
    {
      "Action": [
        "s3:GetObject"
      ],
      "Effect": "Allow",
      "Resource": ["arn:aws:s3:::webodm-test/*"]
    }
  ],
  "Version": "2012-10-17"
}
EOF
}

/******************************************************************************

******************************************************************************/

# resource "aws_key_pair" "deploy" {
#   key_name   = "${var.key_name}"
#   public_key = "${file(var.public_key_path)}"
# }

# resource "aws_instance" "web" {
#   # The connection block tells our provisioner how to communicate with the
#   # instance
#   connection {
#     # The default username for our AMI
#     user = "admin"
# 
#     # The connection will use the local SSH agent for authentication.
#   }
# 
#   instance_type = "t2.micro"
# 
#   ami = "${lookup(var.amis, var.region)}"
# 
#   # The name of our SSH keypair we created above.
#   key_name = "${aws_key_pair.deploy.id}"
# 
#   # Our Security group to allow HTTP and SSH access
#   vpc_security_group_ids = ["${aws_security_group.default.id}"]
# 
#   # We're going to launch into the same subnet as our ELB. In a production
#   # environment it's more common to have a separate private subnet for
#   # backend instances.
#   subnet_id = "${aws_subnet.pub_a.id}"
# 
#   # We run a remote provisioner on the instance after creating it.
#   # In this case, we just install nginx and start it. By default,
#   # this should be on port 80
#   provisioner "remote-exec" {
#     inline = [
#       "sudo apt-get --yes update",
#       "sudo apt-get --yes install nginx",
#       "sudo service nginx start",
#     ]
#   }
# }
