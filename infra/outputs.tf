output "bucket_name" {
  value       = aws_s3_bucket.demo.bucket
  description = "Name of the demo S3 bucket created by this stack"
}
