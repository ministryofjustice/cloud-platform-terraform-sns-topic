#################
# Configuration #
#################
variable "topic_display_name" {
  description = "The display name of your SNS Topic. MUST BE UNDER 10 CHARS"
  type        = string
}

variable "encrypt_sns_kms" {
  description = "If set to true, this will create aws_kms_key and aws_kms_alias resources and add kms_master_key_id in aws_sns_topic resource"
  type        = bool
  default     = false
}

variable "fifo_topic" {
  description = "FIFO means exactly-once processing. Duplicates are not introduced into the topic."
  type        = bool
  default     = false
}

variable "content_based_deduplication" {
  description = "Enables content-based deduplication for FIFO topic."
  type        = bool
  default     = null
}

########
# Tags #
########
variable "business_unit" {
  description = "Area of the MOJ responsible for the service"
  type        = string
}

variable "application" {
  description = "Application name"
  type        = string
}

variable "is_production" {
  description = "Whether this is used for production or not"
  type        = string
}

variable "team_name" {
  description = "Team name"
  type        = string
}

variable "namespace" {
  description = "Namespace name"
  type        = string
}

variable "environment_name" {
  description = "Environment name"
  type        = string
}

variable "infrastructure_support" {
  description = "The team responsible for managing the infrastructure. Should be of the form <team-name> (<team-email>)"
  type        = string
}
