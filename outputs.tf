
output "access_logs_bucket_arn" {
  value       = aws_s3_bucket.access_logs[0].arn
  description = "ARN of the S3 bucket for access logs"
}

output "access_logs_bucket_id" {
  value       = aws_s3_bucket.access_logs[0].id
  description = "ID of the S3 bucket for access logs"
}

output "access_logs_bucket_policy" {
  value       = data.aws_iam_policy_document.access_logs.json
  description = "IAM policy document for the access logs bucket"
}
