# Test S3 integration components for Snowpipe

variables {
  environment        = "test"
  snowflake_database = "ECOMMERCE_DB_TEST"
}

run "validate_s3_integration_components" {
  command = plan

  # Test that module has expected number of outputs
  assert {
    condition     = length(keys(module.snowflake)) >= 5
    error_message = "Module should have at least 5 outputs for complete integration"
  }

  # Test that module has schemas output
  assert {
    condition     = contains(keys(module.snowflake), "schemas")
    error_message = "Module should have schemas output"
  }

  # Test that bronze_stage output exists (provides S3 URL configuration)
  assert {
    condition     = contains(keys(module.snowflake), "bronze_stage")
    error_message = "Module should have bronze_stage output for S3 integration"
  }

  # Test that pipes output exists (provides notification channels for S3)
  assert {
    condition     = contains(keys(module.snowflake), "pipes")
    error_message = "Module should have pipes output for S3 integration"
  }

  # Test that module has S3 bucket notification output
  assert {
    condition     = contains(keys(module.snowflake), "s3_bucket_notification")
    error_message = "Module should have s3_bucket_notification output"
  }
}