output "sns_arn" {
  description = "ARN for the sns topic created"
  value       = module.sns.topic_arn
}

output "sns_name" {
  description = "Name for the sns topic created"
  value       = module.sns.topic_name
}

