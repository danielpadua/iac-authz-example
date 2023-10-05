resource "aws_s3_bucket" "this" {
  bucket = "my-tf-test-bucket-${random_id.this.hex}"

  tags = var.tags
}

resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.this.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}


resource "random_id" "this" {
  byte_length = 8
}
