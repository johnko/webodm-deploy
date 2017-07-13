/******************************************************************************

******************************************************************************/

# IAM role --> "What can I do?"
# instance profile --> "Who am I?"

resource "aws_iam_role" "test_role" {
  name        = "${var.basename}_role"
  description = "Terraform instance role"

  # XXX FIXME XXX Give this a nice path!!!
  # path = "/"

  assume_role_policy = <<POLICYEOF
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
POLICYEOF
}

resource "aws_iam_instance_profile" "test_profile" {
  name = "${var.basename}_profile"
  role = "${aws_iam_role.test_role.name}"

  # XXX FIXME XXX Give this a nice path!!!
  # path = "/"
}

resource "aws_iam_role_policy" "s3_policy" {
  name = "${var.basename}_s3_policy"
  role = "${aws_iam_role.test_role.id}"

  policy = <<POLICYEOF
{
  "Statement": [
    {
      "Action": [
        "s3:ListBucket"
      ],
      "Effect": "Allow",
      "Resource": [
        "arn:aws:s3:::webodm-test"
      ]
    },
    {
      "Action": [
        "s3:GetObject"
      ],
      "Effect": "Allow",
      "Resource": [
        "arn:aws:s3:::webodm-test/*"
      ]
    }
  ],
  "Version": "2012-10-17"
}
POLICYEOF
}
