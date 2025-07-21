variables {
  snowflake_database = "TEST_DB"
}

run "test_yaml_parsing" {
  command = plan

  assert {
    condition     = length(local.table_configs) == 2
    error_message = "Should parse exactly 2 YAML table configs from table-configs directory"
  }

  assert {
    condition     = contains(keys(local.table_configs), "raw_customers")
    error_message = "Should include raw_customers configuration"
  }

  assert {
    condition     = contains(keys(local.table_configs), "raw_stores")
    error_message = "Should include raw_stores configuration"
  }
}

run "test_yaml_content_validation" {
  command = plan

  assert {
    condition     = local.table_configs["raw_customers"].table_name == "raw_customers"
    error_message = "raw_customers config should have correct table_name"
  }

  assert {
    condition     = local.table_configs["raw_customers"].schema == "bronze"
    error_message = "raw_customers should target bronze schema"
  }

  assert {
    condition     = length(local.table_configs["raw_customers"].columns) >= 1
    error_message = "raw_customers should have at least 1 column defined"
  }
}

run "test_schema_definitions" {
  command = plan

  assert {
    condition     = length(local.schemas) == 3
    error_message = "Should define exactly 3 schemas (bronze, silver, gold)"
  }

  assert {
    condition     = local.schemas.bronze.name == "ecommerce_bronze"
    error_message = "Bronze schema should be named ecommerce_bronze"
  }

  assert {
    condition     = local.schemas.silver.name == "ecommerce_silver"
    error_message = "Silver schema should be named ecommerce_silver"
  }

  assert {
    condition     = local.schemas.gold.name == "ecommerce_gold"
    error_message = "Gold schema should be named ecommerce_gold"
  }
}