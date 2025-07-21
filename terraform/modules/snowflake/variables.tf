variable "snowflake_database" {
  description = "Snowflake database name"
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
    table_name  = string
    schema      = string
    description = string
    columns = list(object({
      name        = string
      type        = string
      nullable    = bool
      description = string
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
}

variable "environment" {
  description = "Environment name to prefix resources (e.g., dev, test, prod)"
  type        = string
  default     = "dev"
}