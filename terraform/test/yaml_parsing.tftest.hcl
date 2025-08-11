variables {
  environment        = "test"
  snowflake_database = "ECOMMERCE_DB_TEST"
}

run "test_yaml_parsing" {
  command = plan

  assert {
    condition     = length(local.table_configs) == 15
    error_message = "Should parse exactly 15 YAML table configs from table-configs directory"
  }

  assert {
    condition     = contains(keys(local.table_configs), "categories")
    error_message = "Should include categories configuration"
  }

  assert {
    condition     = contains(keys(local.table_configs), "orders")
    error_message = "Should include orders configuration"
  }
}

run "test_yaml_content_validation" {
  command = plan

  assert {
    condition     = local.table_configs["orders"].name == "orders"
    error_message = "orders config should have correct table name"
  }

  assert {
    condition     = local.table_configs["orders"].schema == "ecommerce_bronze"
    error_message = "orders should target bronze schema"
  }

  assert {
    condition     = length(local.table_configs["orders"].columns) >= 1
    error_message = "orders should have at least 1 column defined"
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