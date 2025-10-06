locals {
  enable_access_logs = var.enable_access_logs && (var.create_access_logs_bucket || var.access_logs_bucket_name != null)

  create_access_logs_bucket = var.enable_access_logs && var.create_access_logs_bucket
  access_logs_bucket        = local.create_access_logs_bucket ? one(aws_s3_bucket.access_logs[*].id) : var.access_logs_bucket_name
}

module "access_logs_label" {
  source  = "cloudposse/label/null"
  version = "0.25.0"

  context    = module.label.context
  attributes = [var.access_logs_bucket_config.name]
}

resource "aws_s3_bucket" "access_logs" {
  # checkov:skip=CKV2_AWS_28:For now the access logs bucket doesn't need KMS encryption (TODO)
  # checkov:skip=CKV2_AWS_62:Event notifications are not required for the access logs bucket
  # checkov:skip=CKV_AWS_18:S3 bucket doesn't need Access logs for now
  # checkov:skip=CKV_AWS_18 Public Access block is enabled, but can't be handled by checkov atm
  # checkov:skip=CKV2_AWS_61:Lifecycle configuration is not (yet) implemented for the access logs bucket
  # checkov:skip=CKV_AWS_144:Cross-region replication is not required for the access logs bucket
  # checkov:skip=CKV_AWS_21:Versioning is disabled by default
  count = local.create_access_logs_bucket ? 1 : 0

  bucket = module.access_logs_label.id

  tags = module.access_logs_label.tags
}

resource "aws_s3_bucket_versioning" "access_logs" {
  count = local.create_access_logs_bucket ? length(aws_s3_bucket.access_logs) : 0

  bucket = aws_s3_bucket.access_logs[0].id

  versioning_configuration {
    status = "Disabled"
  }
}

resource "aws_s3_bucket_ownership_controls" "access_logs" {
  count = local.create_access_logs_bucket ? length(aws_s3_bucket.access_logs) : 0

  bucket = aws_s3_bucket.access_logs[0].id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "access_logs" {
  count = local.create_access_logs_bucket ? length(aws_s3_bucket.access_logs) : 0

  bucket = aws_s3_bucket.access_logs[0].id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = var.access_logs_bucket_config.kms_master_key_id
      sse_algorithm     = var.access_logs_bucket_config.sse_algorithm
    }
  }
}

data "aws_iam_policy_document" "access_logs" {
  statement {
    sid     = "${data.aws_region.current.name}-ELBS3AccessLogs"
    effect  = "Allow"
    actions = ["s3:PutObject"]

    principals {
      type = lookup(local.access_log_principals, data.aws_region.current.name, "Service")
      identifiers = [
        lookup(local.access_log_principals, data.aws_region.current.name, "logdelivery.elasticloadbalancing.amazonaws.com")
      ]
    }

    resources = [
      join("/", compact([
        local.access_logs_bucket,
        var.access_logs_prefix,
        "AWSLogs",
        data.aws_caller_identity.current.account_id,
        "*"
      ]))
    ]
  }
}

resource "aws_s3_bucket_policy" "access_logs" {
  count = local.create_access_logs_bucket ? length(aws_s3_bucket.access_logs) : 0

  bucket = aws_s3_bucket.access_logs[0].id

  policy = data.aws_iam_policy_document.access_logs.json

  depends_on = [aws_s3_bucket_ownership_controls.access_logs]
}

resource "aws_s3_bucket_public_access_block" "access_logs" {
  count = local.create_access_logs_bucket ? length(aws_s3_bucket.access_logs) : 0

  bucket = aws_s3_bucket.access_logs[0].id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  depends_on = [aws_s3_bucket_ownership_controls.access_logs]
}
