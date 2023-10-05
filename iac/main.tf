resource "aws_s3_bucket" "this" {
  bucket = "my-tf-test-bucket-${random_id.this.hex}"

  tags = var.tags
}
resource "random_id" "this" {
  byte_length = 8
}
