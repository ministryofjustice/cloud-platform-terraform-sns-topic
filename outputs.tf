output "user_name" {
  description = "IAM user with access to the topic"
  value       = aws_iam_user.user.name
}

output "topic_name" {
  description = "ARN for the topic"
  value       = aws_sns_topic.new_topic.name
}

output "topic_arn" {
  description = "ARN for the topic"
  value       = aws_sns_topic.new_topic.arn
}

output "access_key_id" {
  description = "The access key ID"
  value       = aws_iam_access_key.user.id
}

output "secret_access_key" {
  description = "The secret access key ID"
  value       = aws_iam_access_key.user.secret
}

output "additional_access_keys" {
  description = "The list of access keys for additional teams"
  value = {
    for team in var.additional_topic_clients : team => {
      user_name         = aws_iam_user.additional_users[team].name
      access_key_id     = aws_iam_access_key.additional_users[team].id
      secret_access_key = aws_iam_access_key.additional_users[team].secret
    }
  }
}