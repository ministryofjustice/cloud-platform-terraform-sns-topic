locals {
  # Generic configuration
  identifier         = "cloud-platform-${var.team_name}-${random_id.id.hex}"
  additional_clients = toset(var.additional_topic_clients)

  # Tags
  default_tags = {
    # Mandatory
    business-unit = var.business_unit
    application   = var.application
    is-production = var.is_production
    owner         = var.team_name
    namespace     = var.namespace # for billing and identification purposes

    # Optional
    environment-name       = var.environment_name
    infrastructure-support = var.infrastructure_support
  }
}

###########################
# Get account information #
###########################
data "aws_caller_identity" "current" {}

########################
# Generate identifiers #
########################
resource "random_id" "id" {
  byte_length = 16
}

#########################
# Create encryption key #
#########################
resource "aws_kms_key" "kms" {
  description = "KMS key for ${local.identifier}"
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
  name          = "alias/${local.identifier}"
  target_key_id = aws_kms_key.kms[0].key_id
}

################
# Create topic #
################
resource "aws_sns_topic" "new_topic" {
  name = local.identifier

  display_name      = var.topic_display_name
  kms_master_key_id = var.encrypt_sns_kms ? aws_kms_key.kms[0].arn : null

  tags = local.default_tags
}

# Legacy long-lived credentials
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

resource "random_id" "additional_user_id" {
  for_each    = local.additional_clients
  byte_length = 16
}

resource "aws_iam_user" "additional_users" {
  for_each = local.additional_clients
  name     = "cp-sns-topic-${random_id.additional_user_id[each.value].hex}"
  path     = "/system/sns-topic-user/${each.value}/"
}

resource "aws_iam_access_key" "additional_users" {
  for_each = local.additional_clients
  user     = aws_iam_user.additional_users[each.value].name
}

resource "aws_iam_user_policy" "additional_users_policy" {
  for_each = local.additional_clients
  name     = "sns-topic"
  policy   = data.aws_iam_policy_document.policy.json
  user     = aws_iam_user.additional_users[each.value].name
}

##############################
# Create IAM role for access #
##############################
data "aws_iam_policy_document" "irsa" {
  version = "2012-10-17"

  statement {
    sid    = "AllowTopicActionsFor${random_id.id.hex}" # this is set to include the hex, so you can merge policies
    effect = "Allow"
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
    resources = [aws_sns_topic.new_topic.arn]
  }
}

resource "aws_iam_policy" "irsa" {
  name   = "cloud-platform-sns-${random_id.id.hex}"
  path   = "/cloud-platform/sns/"
  policy = data.aws_iam_policy_document.irsa.json
  tags   = local.default_tags
}
