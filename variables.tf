variable "context" {
  type = any
  default = {
    enabled             = true
    namespace           = null
    tenant              = null
    environment         = null
    stage               = null
    name                = null
    delimiter           = null
    attributes          = []
    tags                = {}
    additional_tag_map  = {}
    regex_replace_chars = null
    label_order         = []
    id_length_limit     = null
    label_key_case      = null
    label_value_case    = null
    descriptor_formats  = {}
    # Note: we have to use [] instead of null for unset lists due to
    # https://github.com/hashicorp/terraform/issues/28137
    # which was not fixed until Terraform 1.0.0,
    # but we want the default to be all the labels in `label_order`
    # and we want users to be able to prevent all tag generation
    # by setting `labels_as_tags` to `[]`, so we need
    # a different sentinel to indicate "default"
    labels_as_tags = ["unset"]
  }
  description = <<-EOT
    Single object for setting entire context at once.
    See description of individual variables for details.
    Leave string and numeric variables as `null` to use default value.
    Individual variable settings (non-null) override settings in context object,
    except for attributes, tags, and additional_tag_map, which are merged.
  EOT

  validation {
    condition     = lookup(var.context, "label_key_case", null) == null ? true : contains(["lower", "title", "upper"], var.context["label_key_case"])
    error_message = "Allowed values: `lower`, `title`, `upper`."
  }

  validation {
    condition     = lookup(var.context, "label_value_case", null) == null ? true : contains(["lower", "title", "upper", "none"], var.context["label_value_case"])
    error_message = "Allowed values: `lower`, `title`, `upper`, `none`."
  }
}

variable "name" {
  type        = string
  description = "Name of the resource to be labeled. This is used to generate the label key and value."
}

variable "internal" {
  type        = bool
  description = "Whether the load balancer is internal or internet-facing."
  default     = false
}

variable "security_groups_ids" {
  type        = list(string)
  description = "List of security group IDs to associate with the load balancer."
}
variable "subnet_ids" {
  type        = list(string)
  description = "List of subnet IDs to associate with the load balancer."
}

variable "idle_timeout" {
  type        = number
  description = "Idle timeout for the load balancer in seconds."
  default     = 60
}

variable "enable_deletion_protection" {
  type        = bool
  description = "Whether to enable deletion protection for the load balancer."
  default     = false
}

variable "create_access_logs_bucket" {
  type        = bool
  description = "Whether to create an S3 bucket for access logs."
  default     = true
}

variable "enable_access_logs" {
  type        = bool
  description = <<EOT
    Whether to enable writing access logs to the configured S3 bucket is enabled.
    Only when `create_access_logs_bucket` is true, or `access_logs_bucket_name` is set.
  EOT
  default     = false
}

variable "access_logs_bucket_config" {
  type = object({
    name              = optional(string)
    kms_master_key_id = optional(string)
    sse_algorithm     = optional(string, "aws:kms")
  })
  description = <<-EOT
    Configuration for the S3 bucket for access logs.
    The name is used to generate the bucket name.
    The KMS master key ID and SSE algorithm are used for server-side encryption.
  EOT
  default = {
    name              = "access-logs"
    kms_master_key_id = null
    sse_algorithm     = "AES256"
  }
}

variable "access_logs_bucket_name" {
  type        = string
  description = <<-EOT
    Name of existing S3 bucket for access logs.
    Enables access logs for the load balancer, but does not create the bucket.
    If `create_access_logs_bucket` is true, this variable is ignored.
  EOT
  default     = null
}

variable "access_logs_prefix" {
  type        = string
  description = "Prefix for the access logs in the S3 bucket."
  default     = null
}

variable "redirect_http_to_https" {
  type        = bool
  description = "Whether to redirect HTTP traffic to HTTPS."
  default     = false
}
