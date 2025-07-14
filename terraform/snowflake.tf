# Create Snowflake schemas for data processing layers
resource "snowflake_schema" "schemas" {
  for_each = local.schemas
  database = var.snowflake_database
  name     = each.value.name
  comment  = each.value.comment


}

# Create Snowflake tables based on dynamic configurations
resource "snowflake_table" "bronze_table" {
  for_each = local.table_configs
  database = var.snowflake_database
  schema   = snowflake_schema.schemas["bronze"].name
  name     = each.value.table_name

  comment = each.value.description

  dynamic "column" {
    for_each = each.value.columns
    content {
      name     = column.value.name
      type     = column.value.type
      nullable = column.value.nullable
      comment  = column.value.description
    }
  }
}

# Create Snowflake stage for bronze layer
resource "snowflake_stage" "bronze_stage" {
  name                = local.stage.name
  database            = var.snowflake_database
  schema              = snowflake_schema.schemas["bronze"].name
  url                 = local.stage.url
  storage_integration = local.stage.storage_integration
  comment             = local.stage.comment
}
