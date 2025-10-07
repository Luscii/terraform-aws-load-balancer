output "id" {
  value       = aws_lb.this.id
  description = "ID of the load balancer"
}

output "arn" {
  value       = aws_lb.this.arn
  description = "ARN of the load balancer"
}

output "arn_suffix" {
  value       = aws_lb.this.arn_suffix
  description = "ARN suffix of the load balancer"
}

output "dns_name" {
  value       = aws_lb.this.dns_name
  description = "DNS name of the load balancer"
}

output "zone_id" {
  value       = aws_lb.this.zone_id
  description = "Zone ID of the load balancer"
}

output "access_logs_bucket_arn" {
  value       = one(aws_s3_bucket.access_logs[*].arn)
  description = "ARN of the S3 bucket for access logs"
}

output "access_logs_bucket_id" {
  value       = local.create_access_logs_bucket ? one(aws_s3_bucket.access_logs[*].id) : var.access_logs_bucket_name
  description = "ID of the S3 bucket for access logs"
}

output "access_logs_bucket_policy" {
  value       = data.aws_iam_policy_document.access_logs.json
  description = "IAM policy document for the access logs bucket"
}
