resource "aws_lb" "this" {
  #checkov:skip=CKV_AWS_91:Access logging is not required, but configurable and recommended
  #checkov:skip=CKV2_AWS_28:For now we're not implementing WAF, this has to be done in the future (TODO)
  name     = module.label.id
  internal = var.internal

  security_groups = var.security_groups_ids
  subnets         = var.subnet_ids
  idle_timeout    = var.idle_timeout

  drop_invalid_header_fields = true

  enable_deletion_protection = var.enable_deletion_protection

  dynamic "access_logs" {
    for_each = local.enable_access_logs ? [1] : []

    content {
      bucket  = local.access_logs_bucket
      enabled = var.enable_access_logs
      prefix  = var.access_logs_prefix
    }
  }

  tags = module.label.tags
}
