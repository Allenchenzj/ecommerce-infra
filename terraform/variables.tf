variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "ap-southeast-2"
}

variable "project_name" {
  description = "The name of the project"
  type        = string
  default     = "ecommerce_data_platform"

}

variable "environment" {
  description = "The environment for the deployment (e.g., dev, prod)"
  type        = string
  default     = "dev"
}

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

variable "stage_name" {
  description = "Name of the Snowflake external stage"
  type        = string
  default     = "ecommerce_raw_stage"
}

variable "stage_database" {
  description = "Target database for the external stage"
  type        = string
  default     = "ECOMMERCE_DB_YL"
}

variable "stage_schema" {
  description = "Target schema for the external stage"
  type        = string
  default     = "ecommerce_bronze" # case matters
}

variable "stage_url" {
  description = "S3 URL for the external stage"
  type        = string
  default     = "s3://ecommerce-data-ww/ecommerce-raw/"
}

variable "storage_integration" {
  description = "Name of the Snowflake storage integration"
  type        = string
  default     = "S3_INT_ECOMMERCE" # case matters
}

variable "s3_bucket_name" {
  description = "Name of the S3 bucket that holds the data"
  type        = string
  default     = "ecommerce-data-ww"
}

variable "sqs_queue_name" {
  description = "Name of the SQS queue used for Snowpipe notifications"
  type        = string
  default     = "ecommerce-snowpipe-queue"
}

variable "raw_prefix" {
  default     = "ecommerce-raw"
  description = "The prefix under the bucket where raw data is stored"
}

variable "file_suffix" {
  default     = ".parquet"
  description = "File suffix to trigger notification (e.g. .parquet)"
}

variable "notification_channel" {
  type        = string
  description = "ARN of the Snowpipe notification_channel (SQS ARN)"
  default     = null
}