variable "topic_display_name" {
  description = "The display name of your SNS Topic. MUST BE UNDER 10 CHARS"
  type        = string
}

variable "team_name" {
  description = "The name of your team"
  type        = string
}

variable "encrypt_sns_kms" {
  description = "If set to true, this will create aws_kms_key and aws_kms_alias resources and add kms_master_key_id in aws_sns_topic resource"
  type        = bool
  default     = false
}