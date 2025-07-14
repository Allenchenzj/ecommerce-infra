# Terraform Variables
# Define all variables used in the Terraform configuration

# Project Configuration
variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "snowflake-project"
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"
}

# AWS Configuration
variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-southeast-2"
}

# Snowflake Configuration
variable "snowflake" {
  description = "Snowflake credentials loaded from AWS Secrets Manager"
  type = object({
    snowflake_account_name      = string
    snowflake_organization_name = string
    snowflake_username          = string
    snowflake_password          = string
    snowflake_role              = string
    snowflake_warehouse         = string
  })
  sensitive = true
}

variable "snowflake_database" {
  description = "Snowflake database name"
  type        = string
  default     = "ECOMMERENCE_DB_AC"
}
