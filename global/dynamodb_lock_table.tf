/******************************************************************************
DynamoDB Table for Terraform Locking
******************************************************************************/

resource "aws_dynamodb_table" "tf_locks" {
  name           = "terraform_locks"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags {
    Name        = "dynamodb_lock_table"
    Managed_By  = "terraform"
  }
}
