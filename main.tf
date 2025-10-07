module "label" {
  source  = "cloudposse/label/null"
  version = "0.25.0"

  context = var.context
  name    = var.name
}

data "aws_region" "current" {}
data "aws_caller_identity" "current" {}
