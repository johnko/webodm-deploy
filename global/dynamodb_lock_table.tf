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
    Managed_By = "terraform"
  }
}
