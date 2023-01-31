output "user_name" {
  description = "IAM user with access to the topic"
  value       = aws_iam_user.user[var.team_name].name
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
  value       = aws_iam_access_key.user[var.team_name].id
}

output "secret_access_key" {
  description = "The secret access key ID"
  value       = aws_iam_access_key.user[var.team_name].secret
}

output "access_keys" {
  description = "The list of access keys for all teams"
  value = [for key in aws_iam_access_key.user : {
    id     = key.id,
    secret = key.secret
  }]
}
