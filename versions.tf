terraform {
  required_version = ">= 0.14"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.27.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 2.0.0"
    }
  }
}

provider "aws" {
  # Sets the default tags for all taggable things
  default_tags {
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
}
