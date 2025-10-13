module "label" {
  source  = "cloudposse/label/null"
  version = "0.25.0"

  context    = var.context
  name       = var.name
  attributes = var.attributes

  ## ALB name is length can have 32 characters
  id_length_limit = 32
}

data "aws_region" "current" {}
data "aws_caller_identity" "current" {}
