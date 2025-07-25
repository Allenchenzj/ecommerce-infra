# S3 Integration Validation Test
# Tests the aspects of S3 integration that are available in test context

variables {
  environment = "test"
  snowflake_database = "ECOMMERCE_DB_TEST"
}

run "validate_pipe_integration" {
  command = apply

  # Verify Snowpipes exist and have notification channels (which are used by S3)
  assert {
    condition = alltrue([
      for pipe_name, pipe in module.snowflake.pipes :
      can(pipe.notification_channel) && length(pipe.notification_channel) > 0
    ])
    error_message = "All Snowpipes should have notification channels for S3 integration"
  }

  # Verify pipes have auto_ingest enabled (required for S3 event processing)
  assert {
    condition = alltrue([
      for pipe_name, pipe in module.snowflake.pipes :
      pipe.auto_ingest == true
    ])
    error_message = "All Snowpipes should have auto_ingest enabled for S3 integration"
  }

  # Verify pipes have correct table-specific names (used in S3 event filtering)
  assert {
    condition = alltrue([
      for expected_table in ["categories", "orders"] :
      contains(keys(module.snowflake.pipes), expected_table)
    ])
    error_message = "Should have Snowpipes for each table to handle S3 events"
  }

  # Verify bronze stage exists (used in S3 integration URL)
  assert {
    condition     = can(module.snowflake.bronze_stage.url)
    error_message = "Bronze stage should exist with S3 URL for integration"
  }
}