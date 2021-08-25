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

<!--- BEGIN_TF_DOCS --->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.13 |

## Providers

| Name | Version |
|------|---------|
| aws | n/a |
| random | n/a |

## Modules

No Modules.

## Resources

| Name |
|------|
| [aws_caller_identity](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) |
| [aws_iam_access_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_access_key) |
| [aws_iam_policy_document](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) |
| [aws_iam_user](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user) |
| [aws_iam_user_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_policy) |
| [aws_kms_alias](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) |
| [aws_kms_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) |
| [aws_sns_topic](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic) |
| [random_id](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| aws\_region | Region into which the resource will be created | `string` | `"eu-west-2"` | no |
| encrypt\_sns\_kms | If set to true, this will create aws\_kms\_key and aws\_kms\_alias resources and add kms\_master\_key\_id in aws\_sns\_topic resource | `bool` | `false` | no |
| team\_name | The name of your team | `string` | n/a | yes |
| topic\_display\_name | The display name of your SNS Topic. MUST BE UNDER 10 CHARS | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| access\_key\_id | The access key ID |
| secret\_access\_key | The secret access key ID |
| topic\_arn | ARN for the topic |
| topic\_name | ARN for the topic |
| user\_name | IAM user with access to the topic |

<!--- END_TF_DOCS --->