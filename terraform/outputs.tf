# Expose Snowflake module outputs for testing and reference

output "snowflake_schemas" {
  description = "Map of created Snowflake schemas"
  value       = module.snowflake.schemas
}

output "snowflake_bronze_tables" {
  description = "Map of created bronze layer tables"
  value       = module.snowflake.bronze_tables
}

output "snowflake_bronze_stage" {
  description = "Bronze layer stage for S3 integration"
  value       = module.snowflake.bronze_stage
  sensitive   = true
}

output "snowflake_schema_names" {
  description = "Map of schema names by layer"
  value       = module.snowflake.schema_names
}

output "snowflake_pipes" {
  description = "Map of created Snowpipes"
  value       = module.snowflake.pipes
}

output "snowflake_s3_bucket_notification" {
  description = "S3 bucket notification configuration"
  value       = module.snowflake.s3_bucket_notification
}