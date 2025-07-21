# Terraform Providers Configuration
# This file defines the required providers and their versions

terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    snowflake = {
      source  = "snowflakedb/snowflake"
      version = "~> 0.13"
    }
  }

  backend "s3" {
    bucket         = "ecommerce-tfstate-ww"
    key            = "allen/dev/terraform.tfstate"
    dynamodb_table = "allen-tf-lock"
    encrypt        = true
    region         = "ap-southeast-2"
  }
}

# Configure AWS Provider
provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = var.project_name
      Environment = var.environment
      ManagedBy   = "terraform"
    }
  }
}

data "aws_secretsmanager_secret" "snowflake_credentials" {
  name = "snowflake/ecommerce/credentials"
}

data "aws_secretsmanager_secret_version" "snowflake_credentials" {
  secret_id = data.aws_secretsmanager_secret.snowflake_credentials.id
}

locals {
  _snowflake_credentials = jsondecode(data.aws_secretsmanager_secret_version.snowflake_credentials.secret_string)
  account_name           = local._snowflake_credentials.snowflake_account_name
  organization_name      = local._snowflake_credentials.snowflake_organization_name
  username               = local._snowflake_credentials.snowflake_username
  password               = local._snowflake_credentials.snowflake_password
  role                   = local._snowflake_credentials.snowflake_role
  warehouse              = local._snowflake_credentials.snowflake_warehouse
}

# Configure Snowflake Provider
provider "snowflake" {
  account_name      = local.account_name
  organization_name = local.organization_name
  user              = local.username
  password          = local.password
  role              = local.role
  warehouse         = local.warehouse

}

