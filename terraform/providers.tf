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
  #   backend "s3" {
  #     bucket         = "ecommerce-tfstate-ww"
  #     key            = "allen/dev/terraform.tfstate"
  #     dynamodb_table = "allen-tf-lock"
  #     encrypt        = true
  #     region         = "ap-southeast-2"

  #   }
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

# Configure Snowflake Provider
provider "snowflake" {
  account_name      = var.snowflake.snowflake_account_name
  organization_name = var.snowflake.snowflake_organization_name
  user              = var.snowflake.snowflake_username
  password          = var.snowflake.snowflake_password
  role              = var.snowflake.snowflake_role
  warehouse         = var.snowflake.snowflake_warehouse

}
