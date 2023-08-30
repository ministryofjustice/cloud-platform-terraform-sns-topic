output "topic_name" {
  description = "ARN for the topic"
  value       = aws_sns_topic.new_topic.name
}

output "topic_arn" {
  description = "ARN for the topic"
  value       = aws_sns_topic.new_topic.arn
}

output "irsa_policy_arn" {
  description = "IAM policy ARN for access to the SNS topic"
  value       = aws_iam_policy.irsa.arn
}
