
resource "aws_s3_bucket_public_access_block" "terraform_tfstate_block_public_access" {
  bucket                  = aws_s3_bucket.terraform_tfstate.id
  restrict_public_buckets = true
  ignore_public_acls      = true
  block_public_acls       = true
  block_public_policy     = true
}

resource "aws_s3_bucket" "terraform_tfstate" {
  bucket = "<Globally Unique Name of S3 Bucket>"

  lifecycle {
    prevent_destroy = false
  }

  versioning {
    enabled = true
  }

  object_lock_configuration {
    object_lock_enabled = "Enabled"
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_dynamodb_table" "terraform_locks" {
  name         = "<Globally Unique Name of DynamoDB>"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  point_in_time_recovery {
    enabled = true
  }

  depends_on = [aws_s3_bucket.terraform_tfstate]
}