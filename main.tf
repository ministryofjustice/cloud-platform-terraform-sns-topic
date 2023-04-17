data "aws_caller_identity" "current" {}

locals {
  additional_teams = toset(var.additional_team_names)
}
resource "random_id" "id" {
  byte_length = 16
}

resource "aws_kms_key" "kms" {
  description = "KMS key for cloud-platform-${var.team_name}-${random_id.id.hex}"
  count       = var.encrypt_sns_kms ? 1 : 0

  policy = <<EOF
  {
    "Version": "2012-10-17",
    "Id": "key-policy",
    "Statement": [
      {
        "Sid": "Allow administration of the key",
        "Effect": "Allow",
        "Principal": {
          "AWS": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        },
         "Action": [
            "kms:Create*",
            "kms:Describe*",
            "kms:Enable*",
            "kms:List*",
            "kms:Put*",
            "kms:Update*",
            "kms:Revoke*",
            "kms:Disable*",
            "kms:Get*",
            "kms:Delete*",
            "kms:ScheduleKeyDeletion",
            "kms:CancelKeyDeletion"
         ],
        "Resource": "*"
      },
      {
        "Sid": "Allow S3 use of the key",
        "Effect": "Allow",
        "Principal": {
          "Service": "s3.amazonaws.com"
        },
         "Action": [
            "kms:GenerateDataKey*",
            "kms:Decrypt"
         ],
        "Resource": "*"
      },
      {
        "Sid": "Allow IAM use of the key",
        "Effect": "Allow",
        "Principal": {
          "AWS": "*"
        },
         "Action": [
            "kms:GenerateDataKey*",
            "kms:Decrypt"
         ],
        "Resource": "*",
        "Condition": {
            "StringEquals": {
                "kms:CallerAccount": "${data.aws_caller_identity.current.account_id}"
            }
        }
      }
    ]
  }
EOF
}

resource "aws_kms_alias" "alias" {
  count         = var.encrypt_sns_kms ? 1 : 0
  name          = "alias/cloud-platform-${var.team_name}-${random_id.id.hex}"
  target_key_id = aws_kms_key.kms[0].key_id
}

# SNS topics didn't initially support tagging, so the SNS topic name includes
# the team name for identification purposes.
# Tagging was added to this module on 2022-12-28.
resource "aws_sns_topic" "new_topic" {
  name              = "cloud-platform-${var.team_name}-${random_id.id.hex}"
  display_name      = var.topic_display_name
  kms_master_key_id = var.encrypt_sns_kms ? join("", aws_kms_key.kms[*].arn) : ""

  tags = {
    business-unit          = var.business_unit
    application            = var.application
    is-production          = var.is_production
    owner                  = var.team_name
    environment-name       = var.environment_name
    infrastructure-support = var.infrastructure_support
    namespace              = var.namespace
  }
}

resource "aws_iam_user" "user" {
  name = "cp-sns-topic-${random_id.id.hex}"
  path = "/system/sns-topic-user/${var.team_name}/"
}

resource "aws_iam_access_key" "user" {
  user = aws_iam_user.user.name
}

data "aws_iam_policy_document" "policy" {
  statement {
    actions = [
      "sns:ListEndpointsByPlatformApplication",
      "sns:ListPlatformApplications",
      "sns:ListSubscriptions",
      "sns:ListSubscriptionsByTopic",
      "sns:ListTopics",
      "sns:CheckIfPhoneNumberIsOptedOut",
      "sns:GetEndpointAttributes",
      "sns:GetPlatformApplicationAttributes",
      "sns:GetSMSAttributes",
      "sns:GetSubscriptionAttributes",
      "sns:GetTopicAttributes",
      "sns:ListPhoneNumbersOptedOut",
      "sns:ConfirmSubscription",
      "sns:CreatePlatformApplication",
      "sns:CreatePlatformEndpoint",
      "sns:DeleteEndpoint",
      "sns:DeletePlatformApplication",
      "sns:OptInPhoneNumber",
      "sns:Publish",
      "sns:SetEndpointAttributes",
      "sns:SetPlatformApplicationAttributes",
      "sns:SetSMSAttributes",
      "sns:SetSubscriptionAttributes",
      "sns:SetTopicAttributes",
      "sns:Subscribe",
      "sns:Unsubscribe",
    ]

    resources = [
      aws_sns_topic.new_topic.arn,
    ]
  }
}

resource "aws_iam_user_policy" "policy" {
  name   = "sns-topic"
  policy = data.aws_iam_policy_document.policy.json
  user   = aws_iam_user.user.name
}

resource "random_id" "user_id" {
  for_each    = local.additional_teams
  byte_length = 16
}

resource "aws_iam_user" "additional_users" {
  for_each = local.additional_teams
  name     = "cp-sns-topic-${random_id.user_id[each.value].hex}"
  path     = "/system/sns-topic-user/${each.value}/"
}

resource "aws_iam_access_key" "additional_users" {
  for_each = local.additional_teams
  user     = aws_iam_user.additional_users[each.value].name
}

resource "aws_iam_user_policy" "additional_users_policy" {
  for_each = local.additional_teams
  name     = "sns-topic"
  policy   = data.aws_iam_policy_document.policy.json
  user     = aws_iam_user.additional_users[each.value].name
}