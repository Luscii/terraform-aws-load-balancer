# terraform-module-template

Template for creating Terraform modules

## Examples

```tf

module "this" {
  source = ""
}

```

## Configuration

<!-- BEGIN_TF_DOCS -->
### Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.9 |

### Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.97.0 |

### Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_access_logs_label"></a> [access\_logs\_label](#module\_access\_logs\_label) | cloudposse/label/null | 0.25.0 |
| <a name="module_label"></a> [label](#module\_label) | cloudposse/label/null | 0.25.0 |

### Resources

| Name | Type |
|------|------|
| [aws_lb.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb) | resource |
| [aws_lb_listener.http_redirect](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_s3_bucket.access_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_ownership_controls.access_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_ownership_controls) | resource |
| [aws_s3_bucket_policy.access_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_public_access_block.access_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.access_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_s3_bucket_versioning.access_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.access_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_logs_bucket_config"></a> [access\_logs\_bucket\_config](#input\_access\_logs\_bucket\_config) | Configuration for the S3 bucket for access logs.<br/>The name is used to generate the bucket name.<br/>The KMS master key ID and SSE algorithm are used for server-side encryption. | <pre>object({<br/>    name              = optional(string)<br/>    kms_master_key_id = optional(string)<br/>    sse_algorithm     = optional(string, "aws:kms")<br/>  })</pre> | <pre>{<br/>  "kms_master_key_id": null,<br/>  "name": "access-logs",<br/>  "sse_algorithm": "AES256"<br/>}</pre> | no |
| <a name="input_access_logs_bucket_name"></a> [access\_logs\_bucket\_name](#input\_access\_logs\_bucket\_name) | Name of existing S3 bucket for access logs.<br/>Enables access logs for the load balancer, but does not create the bucket.<br/>If `create_access_logs_bucket` is true, this variable is ignored. | `string` | `null` | no |
| <a name="input_access_logs_prefix"></a> [access\_logs\_prefix](#input\_access\_logs\_prefix) | Prefix for the access logs in the S3 bucket. | `string` | `null` | no |
| <a name="input_context"></a> [context](#input\_context) | Single object for setting entire context at once.<br/>See description of individual variables for details.<br/>Leave string and numeric variables as `null` to use default value.<br/>Individual variable settings (non-null) override settings in context object,<br/>except for attributes, tags, and additional\_tag\_map, which are merged. | `any` | <pre>{<br/>  "additional_tag_map": {},<br/>  "attributes": [],<br/>  "delimiter": null,<br/>  "descriptor_formats": {},<br/>  "enabled": true,<br/>  "environment": null,<br/>  "id_length_limit": null,<br/>  "label_key_case": null,<br/>  "label_order": [],<br/>  "label_value_case": null,<br/>  "labels_as_tags": [<br/>    "unset"<br/>  ],<br/>  "name": null,<br/>  "namespace": null,<br/>  "regex_replace_chars": null,<br/>  "stage": null,<br/>  "tags": {},<br/>  "tenant": null<br/>}</pre> | no |
| <a name="input_create_access_logs_bucket"></a> [create\_access\_logs\_bucket](#input\_create\_access\_logs\_bucket) | Whether to create an S3 bucket for access logs. | `bool` | `true` | no |
| <a name="input_enable_access_logs"></a> [enable\_access\_logs](#input\_enable\_access\_logs) | Whether to enable writing access logs to the configured S3 bucket is enabled.<br/>    Only when `create_access_logs_bucket` is true, or `access_logs_bucket_name` is set. | `bool` | n/a | yes |
| <a name="input_enable_deletion_protection"></a> [enable\_deletion\_protection](#input\_enable\_deletion\_protection) | Whether to enable deletion protection for the load balancer. | `bool` | `false` | no |
| <a name="input_idle_timeout"></a> [idle\_timeout](#input\_idle\_timeout) | Idle timeout for the load balancer in seconds. | `number` | `60` | no |
| <a name="input_internal"></a> [internal](#input\_internal) | Whether the load balancer is internal or internet-facing. | `bool` | `false` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the resource to be labeled. This is used to generate the label key and value. | `string` | n/a | yes |
| <a name="input_redirect_http_to_https"></a> [redirect\_http\_to\_https](#input\_redirect\_http\_to\_https) | Whether to redirect HTTP traffic to HTTPS. | `bool` | `false` | no |
| <a name="input_security_groups_ids"></a> [security\_groups\_ids](#input\_security\_groups\_ids) | List of security group IDs to associate with the load balancer. | `list(string)` | n/a | yes |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | List of subnet IDs to associate with the load balancer. | `list(string)` | n/a | yes |

### Outputs

| Name | Description |
|------|-------------|
| <a name="output_access_logs_bucket_arn"></a> [access\_logs\_bucket\_arn](#output\_access\_logs\_bucket\_arn) | ARN of the S3 bucket for access logs |
| <a name="output_access_logs_bucket_id"></a> [access\_logs\_bucket\_id](#output\_access\_logs\_bucket\_id) | ID of the S3 bucket for access logs |
| <a name="output_access_logs_bucket_policy"></a> [access\_logs\_bucket\_policy](#output\_access\_logs\_bucket\_policy) | IAM policy document for the access logs bucket |
<!-- END_TF_DOCS -->
