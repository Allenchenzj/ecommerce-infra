# Test Snowpipe outputs and notification channels
# Validates pipe creation and SQS notification channel ARNs

variables {
  environment = "test"
  snowflake_database = "ECOMMERCE_DB_TEST"
}

run "pipe_outputs" {
  command = apply

  assert {
    condition     = length(module.snowflake.pipes) == 15
    error_message = "Should output exactly 15 Snowpipes"
  }

  assert {
    condition     = can(module.snowflake.pipes["categories"])
    error_message = "Should output categories pipe"
  }

  assert {
    condition     = can(module.snowflake.pipes["orders"])
    error_message = "Should output orders pipe"
  }
}

run "pipe_naming" {
  command = apply

  assert {
    condition     = module.snowflake.pipes["categories"].name == "test_categories_pipe"
    error_message = "categories pipe should have correct name"
  }

  assert {
    condition     = module.snowflake.pipes["orders"].name == "test_orders_pipe"
    error_message = "orders pipe should have correct name"
  }
}

run "pipe_notification_channels" {
  command = apply

  assert {
    condition     = can(module.snowflake.pipes["categories"].notification_channel)
    error_message = "categories pipe should have notification channel"
  }

  assert {
    condition     = can(module.snowflake.pipes["orders"].notification_channel)
    error_message = "orders pipe should have notification channel"
  }

  assert {
    condition     = startswith(module.snowflake.pipes["categories"].notification_channel, "arn:aws:sqs:")
    error_message = "Notification channel should be SQS ARN"
  }
}

run "pipe_configuration" {
  command = apply

  assert {
    condition     = module.snowflake.pipes["categories"].auto_ingest == true
    error_message = "Pipes should have auto_ingest enabled"
  }

  assert {
    condition     = module.snowflake.pipes["categories"].schema == "test_ecommerce_bronze"
    error_message = "Pipes should be in bronze schema"
  }

  assert {
    condition     = module.snowflake.pipes["categories"].database == "ECOMMERCE_DB_TEST"
    error_message = "Pipes should be in correct database"
  }
}