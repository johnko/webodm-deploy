/******************************************************************************
Provider
******************************************************************************/

provider "aws" {
  region = "${var.region}"
}

/******************************************************************************
Remote State and Locking
******************************************************************************/

terraform {
  backend "s3" {
    region         = "ca-central-1"             # ${var.region}
    bucket         = "cace1-tf-marc-orthos"     # ${var.state_bucket_name}
    key            = "global/terraform.tfstate"
    encrypt        = true
    acl            = "private"
    dynamodb_table = "terraform_lock"
  }
}

/******************************************************************************
DynamoDB Table for Terraform Locking
******************************************************************************/

resource "aws_dynamodb_table" "tf_lock" {
  name           = "terraform_lock"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags {
    Name       = "dynamodb_tf_lock"
    Managed_By = "${var.managed_by}"
  }
}

/******************************************************************************
S3 Bucket for Terraform State Storage
******************************************************************************/

resource "aws_s3_bucket" "tf_state" {
  bucket        = "${var.state_bucket_name}"
  acl           = "private"
  force_destroy = false
  region        = "${var.region}"

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = true
  }

  tags {
    Name       = "s3_tf_state"
    Managed_By = "${var.managed_by}"
  }
}

# Make sure that we only ever store encrypted stuff here
# http://docs.aws.amazon.com/AmazonS3/latest/dev/UsingServerSideEncryption.html

resource "aws_s3_bucket_policy" "tf_state" {
  bucket = "${aws_s3_bucket.tf_state.id}"

  policy = <<POLICYEOF
{
  "Id": "PutObjPolicy",
  "Statement": [
    {
      "Action": "s3:PutObject",
      "Condition": {
        "StringNotEquals": {
          "s3:x-amz-server-side-encryption": "AES256"
        }
      },
      "Effect": "Deny",
      "Principal": "*",
      "Resource": "arn:aws:s3:::${var.state_bucket_name}/*",
      "Sid": "DenyIncorrectEncryptionHeader"
    },
    {
      "Action": "s3:PutObject",
      "Condition": {
        "Null": {
          "s3:x-amz-server-side-encryption": "true"
        }
      },
      "Effect": "Deny",
      "Principal": "*",
      "Resource": "arn:aws:s3:::${var.state_bucket_name}/*",
      "Sid": "DenyUnEncryptedObjectUploads"
    }
  ],
  "Version": "2012-10-17"
}
POLICYEOF
}

/******************************************************************************
IAM Groups and Inline Policies
******************************************************************************/

# http://docs.aws.amazon.com/IAM/latest/UserGuide/reference_identifiers.html

resource "aws_iam_group" "administrators" {
  name = "Administrators"

  # XXX FIXME XXX Pick a nice path for this!!!
  # path = "/"
}

# arn:aws:iam::aws:policy/AdministratorAccess

resource "aws_iam_group_policy" "administrator_access" {
  # XXX FIXME XXX Omit this and let terraform pick a random name?
  name  = "AdministratorAccess"
  group = "${aws_iam_group.administrators.id}"

  policy = <<POLICYEOF
{
  "Statement": [
    {
      "Action": "*",
      "Effect": "Allow",
      "Resource": "*"
    }
  ],
  "Version": "2012-10-17"
}
POLICYEOF
}

resource "aws_iam_group" "readonly" {
  name = "ReadOnly"

  # XXX FIXME XXX Pick a nice path for this!!!
  # path = "/"
}

# arn:aws:iam::aws:policy/ReadOnlyAccess

resource "aws_iam_group_policy" "readonly_access" {
  # XXX FIXME XXX Omit this and let terraform pick a random name?
  name  = "ReadOnlyAccess"
  group = "${aws_iam_group.readonly.id}"

  policy = <<POLICYEOF
{
  "Statement": [
    {
      "Action": [
        "acm:Describe*",
        "acm:Get*",
        "acm:List*",
        "apigateway:GET",
        "application-autoscaling:Describe*",
        "appstream:Describe*",
        "appstream:Get*",
        "appstream:List*",
        "athena:List*",
        "athena:Batch*",
        "athena:Get*",
        "autoscaling:Describe*",
        "batch:List*",
        "batch:Describe*",
        "clouddirectory:List*",
        "clouddirectory:BatchRead",
        "clouddirectory:Get*",
        "clouddirectory:LookupPolicy",
        "cloudformation:Describe*",
        "cloudformation:Get*",
        "cloudformation:List*",
        "cloudformation:Estimate*",
        "cloudformation:Preview*",
        "cloudfront:Get*",
        "cloudfront:List*",
        "cloudhsm:List*",
        "cloudhsm:Describe*",
        "cloudhsm:Get*",
        "cloudsearch:Describe*",
        "cloudsearch:List*",
        "cloudtrail:Describe*",
        "cloudtrail:Get*",
        "cloudtrail:List*",
        "cloudtrail:LookupEvents",
        "cloudwatch:Describe*",
        "cloudwatch:Get*",
        "cloudwatch:List*",
        "codebuild:BatchGet*",
        "codebuild:List*",
        "codecommit:BatchGet*",
        "codecommit:Get*",
        "codecommit:GitPull",
        "codecommit:List*",
        "codedeploy:BatchGet*",
        "codedeploy:Get*",
        "codedeploy:List*",
        "codepipeline:List*",
        "codepipeline:Get*",
        "codestar:List*",
        "codestar:Describe*",
        "codestar:Get*",
        "codestar:Verify*",
        "cognito-identity:List*",
        "cognito-identity:Describe*",
        "cognito-identity:Lookup*",
        "cognito-sync:List*",
        "cognito-sync:Describe*",
        "cognito-sync:Get*",
        "cognito-sync:QueryRecords",
        "cognito-idp:AdminList*",
        "cognito-idp:List*",
        "cognito-idp:Describe*",
        "cognito-idp:Get*",
        "config:Deliver*",
        "config:Describe*",
        "config:Get*",
        "config:List*",
        "connect:List*",
        "connect:Describe*",
        "connect:Get*",
        "datapipeline:Describe*",
        "datapipeline:EvaluateExpression",
        "datapipeline:Get*",
        "datapipeline:List*",
        "datapipeline:QueryObjects",
        "datapipeline:Validate*",
        "directconnect:Describe*",
        "directconnect:Confirm*",
        "devicefarm:List*",
        "devicefarm:Get*",
        "discovery:Describe*",
        "discovery:List*",
        "discovery:Get*",
        "dms:Describe*",
        "dms:List*",
        "dms:Test*",
        "ds:Check*",
        "ds:Describe*",
        "ds:Get*",
        "ds:List*",
        "ds:Verify*",
        "dynamodb:BatchGet*",
        "dynamodb:Describe*",
        "dynamodb:Get*",
        "dynamodb:List*",
        "dynamodb:Query",
        "dynamodb:Scan",
        "ec2:Describe*",
        "ec2:Get*",
        "ec2messages:Get*",
        "ecr:BatchCheck*",
        "ecr:BatchGet*",
        "ecr:Describe*",
        "ecr:Get*",
        "ecr:List*",
        "ecs:Describe*",
        "ecs:List*",
        "elasticache:Describe*",
        "elasticache:List*",
        "elasticbeanstalk:Check*",
        "elasticbeanstalk:Describe*",
        "elasticbeanstalk:List*",
        "elasticbeanstalk:Request*",
        "elasticbeanstalk:Retrieve*",
        "elasticbeanstalk:Validate*",
        "elasticfilesystem:Describe*",
        "elasticloadbalancing:Describe*",
        "elasticmapreduce:Describe*",
        "elasticmapreduce:List*",
        "elasticmapreduce:View*",
        "elastictranscoder:List*",
        "elastictranscoder:Read*",
        "es:Describe*",
        "es:List*",
        "es:ESHttpGet",
        "es:ESHttpHead",
        "events:Describe*",
        "events:List*",
        "events:Test*",
        "firehose:Describe*",
        "firehose:List*",
        "gamelift:List*",
        "gamelift:Get*",
        "gamelift:Describe*",
        "gamelift:RequestUploadCredentials",
        "gamelift:ResolveAlias",
        "gamelift:Search*",
        "glacier:List*",
        "glacier:Describe*",
        "glacier:Get*",
        "health:Describe*",
        "health:Get*",
        "health:List*",
        "iam:Generate*",
        "iam:Get*",
        "iam:List*",
        "iam:Simulate*",
        "importexport:Get*",
        "importexport:List*",
        "inspector:Describe*",
        "inspector:Get*",
        "inspector:List*",
        "inspector:Preview*",
        "inspector:LocalizeText",
        "iot:Describe*",
        "iot:Get*",
        "iot:List*",
        "kinesisanalytics:Describe*",
        "kinesisanalytics:Discover*",
        "kinesisanalytics:Get*",
        "kinesisanalytics:List*",
        "kinesis:Describe*",
        "kinesis:Get*",
        "kinesis:List*",
        "kms:Describe*",
        "kms:Get*",
        "kms:List*",
        "lambda:List*",
        "lambda:Get*",
        "lex:Get*",
        "lightsail:Get*",
        "lightsail:Is*",
        "lightsail:Download*",
        "logs:Describe*",
        "logs:Get*",
        "logs:FilterLogEvents",
        "logs:TestMetricFilter",
        "machinelearning:Describe*",
        "machinelearning:Get*",
        "mobileanalytics:Get*",
        "mobilehub:Get*",
        "mobilehub:List*",
        "mobilehub:Validate*",
        "mobilehub:Verify*",
        "mobiletargeting:Get*",
        "opsworks:Describe*",
        "opsworks:Get*",
        "opsworks-cm:Describe*",
        "organizations:Describe*",
        "organizations:List*",
        "polly:Describe*",
        "polly:Get*",
        "polly:List*",
        "polly:SynthesizeSpeech",
        "rekognition:CompareFaces",
        "rekognition:Detect*",
        "rekognition:List*",
        "rekognition:Search*",
        "rds:Describe*",
        "rds:List*",
        "rds:Download*",
        "redshift:Describe*",
        "redshift:View*",
        "redshift:Get*",
        "route53:Get*",
        "route53:List*",
        "route53:Test*",
        "route53domains:Check*",
        "route53domains:Get*",
        "route53domains:List*",
        "route53domains:View*",
        "s3:Get*",
        "s3:List*",
        "s3:Head*",
        "sdb:Get*",
        "sdb:List*",
        "sdb:Select*",
        "servicecatalog:List*",
        "servicecatalog:Scan*",
        "servicecatalog:Search*",
        "servicecatalog:Describe*",
        "ses:Get*",
        "ses:List*",
        "ses:Describe*",
        "ses:Verify*",
        "shield:Describe*",
        "shield:List*",
        "sns:Get*",
        "sns:List*",
        "sns:Check*",
        "sqs:Get*",
        "sqs:List*",
        "sqs:Receive*",
        "ssm:Describe*",
        "ssm:Get*",
        "ssm:List*",
        "states:List*",
        "states:Describe*",
        "states:GetExecutionHistory",
        "storagegateway:Describe*",
        "storagegateway:List*",
        "sts:Get*",
        "swf:Count*",
        "swf:Describe*",
        "swf:Get*",
        "swf:List*",
        "tag:Get*",
        "trustedadvisor:Describe*",
        "waf:Get*",
        "waf:List*",
        "waf-regional:List*",
        "waf-regional:Get*",
        "workdocs:Describe*",
        "workdocs:Get*",
        "workdocs:CheckAlias",
        "workmail:Describe*",
        "workmail:Get*",
        "workmail:List*",
        "workmail:Search*",
        "workspaces:Describe*",
        "xray:BatchGet*",
        "xray:Get*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ],
  "Version": "2012-10-17"
}
POLICYEOF
}
