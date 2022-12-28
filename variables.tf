# Module variables
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

# Used for naming things and tags
variable "business-unit" {
  description = "Area of the MOJ responsible for the service"
  type        = string
}

variable "application" {
  description = "Application name"
  type        = string
}

variable "is-production" {
  description = "Whether the environment is production or not"
  type        = string
  default     = "false"
}

variable "team_name" {
  description = "Team name"
  type        = string
}

variable "environment-name" {
  description = "Environment name"
  type        = string
}

variable "infrastructure-support" {
  description = "The team responsible for managing the infrastructure. Should be of the form <team-name> (<team-email>)"
  type        = string
}

variable "namespace" {
  description = "Namespace name"
  type        = string
}
