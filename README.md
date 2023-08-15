# cloud-platform-terraform-sns-topic

[![Releases](https://img.shields.io/github/v/release/ministryofjustice/cloud-platform-terraform-sns-topic.svg)](https://github.com/ministryofjustice/cloud-platform-terraform-sns-topic/releases)

This Terraform module will create an [Amazon SNS](https://docs.aws.amazon.com/sns/latest/dg/sns-create-topic.html) topic for use on the Cloud Platform.

## Usage

```hcl
module "sns_topic" {
  source = "github.com/ministryofjustice/cloud-platform-terraform-sns-topic?ref=version" # use the latest release

  # Configuration
  topic_display_name = "example"
  encrypt_sns_kms    = true

  # Tags
  business_unit          = var.business_unit
  application            = var.application
  is_production          = var.is_production
  team_name              = var.team_name # also used for naming the topic
  namespace              = var.namespace
  environment_name       = var.environment
  infrastructure_support = var.infrastructure_support
}
```

### Adding a subscription to SQS

For an SQS queue defined in the same namespace, you can add an SNS topic subscription:

```hcl
resource "aws_sns_topic_subscription" "queue" {
  topic_arn     = module.sns_topic.topic_arn
  endpoint      = module.sqs_queue.sqs_arn
  protocol      = "sqs"
  filter_policy = "{\"field_name\": [\"string_pattern\", \"string_pattern\", \"...\"]}"
}
```

See the [examples/](examples/) folder for more information.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.2.5 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.0.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 2.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.0.0 |
| <a name="provider_random"></a> [random](#provider\_random) | >= 2.0.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_access_key.additional_users](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_access_key) | resource |
| [aws_iam_access_key.user](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_access_key) | resource |
| [aws_iam_policy.irsa](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_user.additional_users](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user) | resource |
| [aws_iam_user.user](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user) | resource |
| [aws_iam_user_policy.additional_users_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_policy) | resource |
| [aws_iam_user_policy.policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_policy) | resource |
| [aws_kms_alias.alias](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.kms](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_sns_topic.new_topic](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic) | resource |
| [random_id.additional_user_id](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |
| [random_id.id](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.irsa](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_topic_clients"></a> [additional\_topic\_clients](#input\_additional\_topic\_clients) | A list of additional clients that require access to the topic. A dedicated IAM user and access key will be created for each client. | `list` | `[]` | no |
| <a name="input_application"></a> [application](#input\_application) | Application name | `string` | n/a | yes |
| <a name="input_business_unit"></a> [business\_unit](#input\_business\_unit) | Area of the MOJ responsible for the service | `string` | n/a | yes |
| <a name="input_encrypt_sns_kms"></a> [encrypt\_sns\_kms](#input\_encrypt\_sns\_kms) | If set to true, this will create aws\_kms\_key and aws\_kms\_alias resources and add kms\_master\_key\_id in aws\_sns\_topic resource | `bool` | `false` | no |
| <a name="input_environment_name"></a> [environment\_name](#input\_environment\_name) | Environment name | `string` | n/a | yes |
| <a name="input_infrastructure_support"></a> [infrastructure\_support](#input\_infrastructure\_support) | The team responsible for managing the infrastructure. Should be of the form <team-name> (<team-email>) | `string` | n/a | yes |
| <a name="input_is_production"></a> [is\_production](#input\_is\_production) | Whether this is used for production or not | `string` | n/a | yes |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace name | `string` | n/a | yes |
| <a name="input_team_name"></a> [team\_name](#input\_team\_name) | Team name | `string` | n/a | yes |
| <a name="input_topic_display_name"></a> [topic\_display\_name](#input\_topic\_display\_name) | The display name of your SNS Topic. MUST BE UNDER 10 CHARS | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_access_key_id"></a> [access\_key\_id](#output\_access\_key\_id) | The access key ID |
| <a name="output_additional_access_keys"></a> [additional\_access\_keys](#output\_additional\_access\_keys) | The list of access keys for additional teams |
| <a name="output_irsa_policy_arn"></a> [irsa\_policy\_arn](#output\_irsa\_policy\_arn) | n/a |
| <a name="output_secret_access_key"></a> [secret\_access\_key](#output\_secret\_access\_key) | The secret access key ID |
| <a name="output_topic_arn"></a> [topic\_arn](#output\_topic\_arn) | ARN for the topic |
| <a name="output_topic_name"></a> [topic\_name](#output\_topic\_name) | ARN for the topic |
| <a name="output_user_name"></a> [user\_name](#output\_user\_name) | IAM user with access to the topic |
<!-- END_TF_DOCS -->

## Tags

Some of the inputs for this module are tags. All infrastructure resources must be tagged to meet the MOJ Technical Guidance on [Documenting owners of infrastructure](https://technical-guidance.service.justice.gov.uk/documentation/standards/documenting-infrastructure-owners.html).

You should use your namespace variables to populate these. See the [Usage](#usage) section for more information.

## Reading Material

- [Cloud Platform user guide](https://user-guide.cloud-platform.service.justice.gov.uk/#cloud-platform-user-guide)
- [Amazon Simple Notification Service developer guide](https://docs.aws.amazon.com/sns/latest/dg/welcome.html)
