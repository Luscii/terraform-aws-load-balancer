locals {
  enable_access_logs = var.create_access_logs_bucket || var.access_logs_bucket_name != null

  access_logs_bucket = var.create_access_logs_bucket ? aws_s3_bucket.access_logs[0].id : var.access_logs_bucket_name
}

module "access_logs_label" {
  source  = "cloudposse/label/null"
  version = "0.25.0"

  context    = module.label.context
  attributes = [var.access_logs_bucket_config.name]
}

resource "aws_s3_bucket" "access_logs" {
  count = var.create_access_logs_bucket ? 1 : 0

  bucket = module.access_logs_label.id

  tags = module.access_logs_label.tags
}

resource "aws_s3_bucket_versioning" "access_logs" {
  count = var.create_access_logs_bucket ? 1 : 0

  bucket = aws_s3_bucket.access_logs[0].id

  versioning_configuration {
    status = "Disabled"
  }
}

resource "aws_s3_bucket_ownership_controls" "access_logs" {
  count = var.create_access_logs_bucket ? 1 : 0

  bucket = aws_s3_bucket.access_logs[0].id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "access_logs" {
  count = var.create_access_logs_bucket ? 1 : 0

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

locals {
  #  This is a map of AWS regions to the corresponding IAM principal for access logs.
  #  The keys are the region names, and the values are the corresponding IAM principal ARNs.
  #  https://docs.aws.amazon.com/elasticloadbalancing/latest/application/enable-access-logging.html

  access_log_principals = {
    "us-east-1"      = "arn:aws:iam::127311923021:root"
    "us-east-2"      = "arn:aws:iam::033677994240:root"
    "us-west-1"      = "arn:aws:iam::027434742980:root"
    "us-west-2"      = "arn:aws:iam::797873946194:root"
    "af-south-1"     = "arn:aws:iam::098369216593:root"
    "ap-east-1"      = "arn:aws:iam::754344448648:root"
    "ap-southeast-3" = "arn:aws:iam::589379963580:root"
    "ap-south-1"     = "arn:aws:iam::718504428378:root"
    "ap-northeast-3" = "arn:aws:iam::383597477331:root"
    "ap-northeast-2" = "arn:aws:iam::600734575887:root"
    "ap-southeast-1" = "arn:aws:iam::114774131450:root"
    "ap-southeast-2" = "arn:aws:iam::783225319266:root"
    "ap-northeast-1" = "arn:aws:iam::582318560864:root"
    "ca-central-1"   = "arn:aws:iam::985666609251:root"
    "eu-central-1"   = "arn:aws:iam::054676820928:root"
    "eu-west-1"      = "arn:aws:iam::156460612806:root"
    "eu-west-2"      = "arn:aws:iam::652711504416:root"
    "eu-south-1"     = "arn:aws:iam::635631232127:root"
    "eu-west-3"      = "arn:aws:iam::009996457667:root"
    "eu-north-1"     = "arn:aws:iam::897822967062:root"
    "me-south-1"     = "arn:aws:iam::076674570225:root"
    "sa-east-1"      = "arn:aws:iam::507241528517:root"
  }
}

resource "aws_s3_bucket_policy" "access_logs" {
  count = var.create_access_logs_bucket ? 1 : 0

  bucket = aws_s3_bucket.access_logs[0].id

  policy = data.aws_iam_policy_document.access_logs.json

  depends_on = [aws_s3_bucket_ownership_controls.access_logs]
}

resource "aws_s3_bucket_public_access_block" "access_logs" {
  count = var.create_access_logs_bucket ? 1 : 0

  bucket = aws_s3_bucket.access_logs[0].id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  depends_on = [aws_s3_bucket_ownership_controls.access_logs]
}
