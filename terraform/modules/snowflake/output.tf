output "schemas" {
  description = "Map of created Snowflake schemas"
  value       = snowflake_schema.schemas
}

output "schema_names" {
  description = "Map of schema names by layer"
  value = {
    for key, schema in snowflake_schema.schemas : key => schema.name
  }
}

output "bronze_tables" {
  description = "Map of created bronze layer tables"
  value       = snowflake_table.bronze_table
}

output "bronze_stage" {
  description = "Bronze layer stage for S3 integration"
  value       = snowflake_stage.bronze_stage
}

output "pipes" {
  description = "Map of created Snowpipes"
  value       = snowflake_pipe.pipes
}

output "s3_bucket_notification" {
  description = "S3 bucket notification configuration"
  value       = aws_s3_bucket_notification.snowflake_notifications
}