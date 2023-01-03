terraform {
  required_version = ">= 0.14"
}

provider "aws" {
  access_key                  = "mock_access_key"
  secret_key                  = "mock_secret_key"
  region                      = "eu-west-2"
  s3_force_path_style         = true
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true

  endpoints {
    ec2 = "http://localhost:4566"
    iam = "http://localhost:4566"
    sns = "http://localhost:4566"
    sts = "http://localhost:4566"
  }
}

module "sns" {
  source = "../.."

  topic_display_name     = "cloud-platform-topic-display-name"
  business_unit          = "example"
  application            = "example"
  is_production          = "false"
  team_name              = "cloud-platform"
  environment_name       = "example"
  infrastructure_support = "example"
  namespace              = "example"
}

