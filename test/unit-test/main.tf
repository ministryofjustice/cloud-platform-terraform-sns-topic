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

  team_name          = "cloud-platform"
  topic_display_name = "cloud-platform-topic-display-name"

}

