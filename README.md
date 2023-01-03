# cloud-platform-terraform-sns-topic

[![Releases](https://img.shields.io/github/release/ministryofjustice/cloud-platform-terraform-sns-topic.svg)](https://github.com/ministryofjustice/cloud-platform-terraform-sns-topic/releases)

Terraform module that will create an SNS Topic in AWS, along with an IAM User to access it.

## Usage

```hcl
module "example_sns_topic" {
  source = "github.com/ministryofjustice/cloud-platform-terraform-sns?ref=version"

  team_name          = "example-team"
  topic_display_name = "example-topic-display-name"
  
  providers = {
    aws = aws.london
  }
}
```

## SQS Subscription

For an SQS queue defined in the same namespace's /resources, a subscription can be added with a syntax like

```hcl
resource "aws_sns_topic_subscription" "example-queue-subscription" {
  provider      = "aws.london"
  topic_arn     = "${module.example_sns_topic.topic_arn}"
  protocol      = "sqs"
  endpoint      = "${module.example_sqs.sqs_arn}"
  filter_policy = "{\"field_name\": [\"string_pattern\", \"string_pattern\", \"...\"]}"
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.27.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 2.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.27.0 |
| <a name="provider_random"></a> [random](#provider\_random) | >= 2.0.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_access_key.user](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_access_key) | resource |
| [aws_iam_user.user](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user) | resource |
| [aws_iam_user_policy.policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_policy) | resource |
| [aws_kms_alias.alias](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.kms](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_sns_topic.new_topic](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic) | resource |
| [random_id.id](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_application"></a> [application](#input\_application) | Application name | `string` | n/a | yes |
| <a name="input_business_unit"></a> [business\_unit](#input\_business\_unit) | Area of the MOJ responsible for the service | `string` | n/a | yes |
| <a name="input_encrypt_sns_kms"></a> [encrypt\_sns\_kms](#input\_encrypt\_sns\_kms) | If set to true, this will create aws\_kms\_key and aws\_kms\_alias resources and add kms\_master\_key\_id in aws\_sns\_topic resource | `bool` | `false` | no |
| <a name="input_environment_name"></a> [environment\_name](#input\_environment\_name) | Environment name | `string` | n/a | yes |
| <a name="input_infrastructure_support"></a> [infrastructure\_support](#input\_infrastructure\_support) | The team responsible for managing the infrastructure. Should be of the form <team-name> (<team-email>) | `string` | n/a | yes |
| <a name="input_is_production"></a> [is\_production](#input\_is\_production) | Whether the environment is production or not | `string` | `"false"` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace name | `string` | n/a | yes |
| <a name="input_team_name"></a> [team\_name](#input\_team\_name) | Team name | `string` | n/a | yes |
| <a name="input_topic_display_name"></a> [topic\_display\_name](#input\_topic\_display\_name) | The display name of your SNS Topic. MUST BE UNDER 10 CHARS | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_access_key_id"></a> [access\_key\_id](#output\_access\_key\_id) | The access key ID |
| <a name="output_secret_access_key"></a> [secret\_access\_key](#output\_secret\_access\_key) | The secret access key ID |
| <a name="output_topic_arn"></a> [topic\_arn](#output\_topic\_arn) | ARN for the topic |
| <a name="output_topic_name"></a> [topic\_name](#output\_topic\_name) | ARN for the topic |
| <a name="output_user_name"></a> [user\_name](#output\_user\_name) | IAM user with access to the topic |
<!-- END_TF_DOCS -->
