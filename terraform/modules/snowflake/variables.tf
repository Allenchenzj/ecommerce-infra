# variable "snowflake_account" {
#   description = "Snowflake account identifier"
#   type        = string
# }

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-southeast-2"
}

variable "environment" {
  description = "Environment name to prefix resources (e.g., dev, test, prod)"
  type        = string
  default     = "dev"
}

variable "snowflake_database" {
  description = "Snowflake database name (e.g., ECOMMERCE_DB_YL, ECOMMERCE_DB_TEST)"
  type        = string
}

variable "schemas" {
  description = "Schema definitions for data processing layers"
  type = map(object({
    name    = string
    comment = string
  }))
}

variable "table_configs" {
  description = "Table configurations parsed from YAML files"
  type = map(object({
    name  = string
    schema      = string
    # description = string
    columns = list(object({
      name        = string
      type        = string
      # nullable    = bool
      comment = string
    }))
  }))
}

variable "stage" {
  description = "Stage configuration for S3 integration"
  type = object({
    name                = string
    comment             = string
    url                 = string
    storage_integration = string
  })
}

variable "s3_bucket_name" {
  description = "S3 bucket name for data landing zone"
  type        = string
  default     = "ecommerce-data-ww"
}

variable "raw_prefix" {
  description = "The prefix under the bucket where raw data is stored"
  type        = string
  # This prefix is used to organize raw data files in the S3 bucket
  default     = "ecommerce-raw"
}

variable "file_suffix" {
  description = "File suffix to trigger notification (e.g. .parquet)"
  type        = string
  # This suffix is used to filter files for processing in Snowpipe
  default     = ".parquet"
}