# Test Snowpipe outputs and notification channels
# Validates pipe creation and SQS notification channel ARNs

variables {
  environment = "test"
}

run "test_pipe_outputs" {
  command = apply

  assert {
    condition     = length(module.snowflake.pipes) == 2
    error_message = "Should output exactly 2 Snowpipes"
  }

  assert {
    condition     = can(module.snowflake.pipes["raw_customers"])
    error_message = "Should output raw_customers pipe"
  }

  assert {
    condition     = can(module.snowflake.pipes["raw_stores"])
    error_message = "Should output raw_stores pipe"
  }
}

run "test_pipe_naming" {
  command = apply

  assert {
    condition     = module.snowflake.pipes["raw_customers"].name == "test_raw_customers_pipe"
    error_message = "raw_customers pipe should have correct name"
  }

  assert {
    condition     = module.snowflake.pipes["raw_stores"].name == "test_raw_stores_pipe"
    error_message = "raw_stores pipe should have correct name"
  }
}

run "test_pipe_notification_channels" {
  command = apply

  assert {
    condition     = can(module.snowflake.pipes["raw_customers"].notification_channel)
    error_message = "raw_customers pipe should have notification channel"
  }

  assert {
    condition     = can(module.snowflake.pipes["raw_stores"].notification_channel)
    error_message = "raw_stores pipe should have notification channel"
  }

  assert {
    condition     = startswith(module.snowflake.pipes["raw_customers"].notification_channel, "arn:aws:sqs:")
    error_message = "Notification channel should be SQS ARN"
  }
}

run "test_pipe_configuration" {
  command = apply

  assert {
    condition     = module.snowflake.pipes["raw_customers"].auto_ingest == true
    error_message = "Pipes should have auto_ingest enabled"
  }

  assert {
    condition     = module.snowflake.pipes["raw_customers"].schema == "test_ecommerce_bronze"
    error_message = "Pipes should be in bronze schema"
  }

  assert {
    condition     = module.snowflake.pipes["raw_customers"].database == var.snowflake_database
    error_message = "Pipes should be in correct database"
  }
}