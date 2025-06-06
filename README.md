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

### Example with First-In-First-Out (FIFO)

```hcl
module "sns_topic_fifo" {
  source = "github.com/ministryofjustice/cloud-platform-terraform-sns-topic?ref=version" # use the latest release

  # Configuration
  topic_display_name          = "example-sns-fifo"
  encrypt_sns_kms             = true
  fifo_topic                  = true
  content_based_deduplication = true

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

## Team name caveat

This module utilises your environemnt `team_name` variable in the naming of your SNS topic, in the format `cloud-platform-<var.team_name>-<random hex string>`. This historically introduced an issue whereby a team name change would result in Terraform forcefully replacing the SNS topic. To get around this issue, a [lifecycle](https://developer.hashicorp.com/terraform/language/meta-arguments/lifecycle) `ignore_changes` block has been introduced, so that team name changes can be made without causing this issue.

However, its important to note that if you do change the team name in your environment variables, it will not be reflected in the SNS topic name. If you want to update the name, you will need to look at deleting and recreating your SNS topic(s). 

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
| [aws_iam_policy.irsa](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_kms_alias.alias](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.kms](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_sns_topic.new_topic](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic) | resource |
| [random_id.id](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.irsa](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_application"></a> [application](#input\_application) | Application name | `string` | n/a | yes |
| <a name="input_business_unit"></a> [business\_unit](#input\_business\_unit) | Area of the MOJ responsible for the service | `string` | n/a | yes |
| <a name="input_content_based_deduplication"></a> [content\_based\_deduplication](#input\_content\_based\_deduplication) | Enables content-based deduplication for FIFO topic. | `bool` | `null` | no |
| <a name="input_encrypt_sns_kms"></a> [encrypt\_sns\_kms](#input\_encrypt\_sns\_kms) | If set to true, this will create aws\_kms\_key and aws\_kms\_alias resources and add kms\_master\_key\_id in aws\_sns\_topic resource | `bool` | `false` | no |
| <a name="input_environment_name"></a> [environment\_name](#input\_environment\_name) | Environment name | `string` | n/a | yes |
| <a name="input_fifo_topic"></a> [fifo\_topic](#input\_fifo\_topic) | FIFO means exactly-once processing. Duplicates are not introduced into the topic. | `bool` | `false` | no |
| <a name="input_infrastructure_support"></a> [infrastructure\_support](#input\_infrastructure\_support) | The team responsible for managing the infrastructure. Should be of the form <team-name> (<team-email>) | `string` | n/a | yes |
| <a name="input_is_production"></a> [is\_production](#input\_is\_production) | Whether this is used for production or not | `string` | n/a | yes |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace name | `string` | n/a | yes |
| <a name="input_team_name"></a> [team\_name](#input\_team\_name) | Team name | `string` | n/a | yes |
| <a name="input_topic_display_name"></a> [topic\_display\_name](#input\_topic\_display\_name) | The display name of your SNS Topic. MUST BE UNDER 10 CHARS | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_irsa_policy_arn"></a> [irsa\_policy\_arn](#output\_irsa\_policy\_arn) | IAM policy ARN for access to the SNS topic |
| <a name="output_topic_arn"></a> [topic\_arn](#output\_topic\_arn) | ARN for the topic |
| <a name="output_topic_name"></a> [topic\_name](#output\_topic\_name) | ARN for the topic |
<!-- END_TF_DOCS -->

## Tags

Some of the inputs for this module are tags. All infrastructure resources must be tagged to meet the MOJ Technical Guidance on [Documenting owners of infrastructure](https://technical-guidance.service.justice.gov.uk/documentation/standards/documenting-infrastructure-owners.html).

You should use your namespace variables to populate these. See the [Usage](#usage) section for more information.

## Reading Material

- [Cloud Platform user guide](https://user-guide.cloud-platform.service.justice.gov.uk/#cloud-platform-user-guide)
- [Amazon Simple Notification Service developer guide](https://docs.aws.amazon.com/sns/latest/dg/welcome.html)
