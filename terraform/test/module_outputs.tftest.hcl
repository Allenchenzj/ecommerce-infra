# Test module outputs validation
# Validates all outputs from the Snowflake module

variables {
  environment        = "test"
  snowflake_database = "ECOMMERCE_DB_TEST"
}

run "test_schema_outputs" {
  command = plan

  assert {
    condition     = length(module.snowflake.schema_names) == 3
    error_message = "Should output 3 schema names"
  }

  assert {
    condition     = module.snowflake.schema_names.bronze == "test_ecommerce_bronze"
    error_message = "Bronze schema name output should be correct"
  }

  assert {
    condition     = module.snowflake.schema_names.silver == "test_ecommerce_silver"
    error_message = "Silver schema name output should be correct"
  }

  assert {
    condition     = module.snowflake.schema_names.gold == "test_ecommerce_gold"
    error_message = "Gold schema name output should be correct"
  }
}

run "test_table_outputs" {
  command = apply

  assert {
    condition     = length(module.snowflake.bronze_tables) == 15
    error_message = "Should output exactly 15 bronze tables"
  }

  assert {
    condition     = can(module.snowflake.bronze_tables["categories"])
    error_message = "Should output categories table"
  }

  assert {
    condition     = can(module.snowflake.bronze_tables["suppliers"])
    error_message = "Should output suppliers table"
  }

  assert {
    condition     = module.snowflake.bronze_tables["order_items"].schema == "test_ecommerce_bronze"
    error_message = "order_items table should be in bronze schema"
  }
}

run "test_stage_output" {
  command = plan

  assert {
    condition     = module.snowflake.bronze_stage.name == "test_ecommerce_stage"
    error_message = "Stage output should have correct name"
  }

  assert {
    condition     = module.snowflake.bronze_stage.url == "s3://ecommerce-data-ww/ecommerce-raw/"
    error_message = "Stage should point to correct S3 URL"
  }

  assert {
    condition     = module.snowflake.bronze_stage.storage_integration == "S3_INT_ECOMMERCE"
    error_message = "Stage should use correct storage integration"
  }

  assert {
    condition     = module.snowflake.bronze_stage.schema == "test_ecommerce_bronze"
    error_message = "Stage should be in bronze schema"
  }
}