# Test Snowflake infrastructure integration

run "validate_snowflake_resources" {
  command = plan

  # Test basic module accessibility - use simple key count
  assert {
    condition     = length(keys(module.snowflake)) >= 5
    error_message = "Module should have at least 5 outputs (schemas, tables, pipes, etc.)"
  }

  # Test that we have the expected number of outputs
  assert {
    condition     = contains(keys(module.snowflake), "pipes")
    error_message = "Module should have pipes output"
  }

  assert {
    condition     = contains(keys(module.snowflake), "bronze_tables")
    error_message = "Module should have bronze_tables output"
  }

  assert {
    condition     = contains(keys(module.snowflake), "schemas")
    error_message = "Module should have schemas output"
  }
}