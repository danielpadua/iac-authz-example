resource "aws_s3_bucket" "this" {
  bucket = "my-tf-test-bucket"

  tags = var.tags
}
