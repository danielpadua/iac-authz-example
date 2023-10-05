
output "bucket_arn" {
  value       = aws_s3_bucket.this.arn
  description = "Managed AWS S3 bucket ARN"
}
