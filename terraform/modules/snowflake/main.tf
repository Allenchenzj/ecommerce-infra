# Create Snowflake schemas for data processing layers
resource "snowflake_schema" "schemas" {
  for_each = var.schemas
  database = var.snowflake_database
  name     = "${var.environment}_${each.value.name}"
  comment  = each.value.comment
}

# Create Snowflake tables based on dynamic configurations
resource "snowflake_table" "bronze_table" {
  for_each = var.table_configs
  database = var.snowflake_database
  schema   = snowflake_schema.schemas["bronze"].name
  name     = "${var.environment}_${each.value.table_name}"

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
  name                = "${var.environment}_${var.stage.name}"
  database            = var.snowflake_database
  schema              = snowflake_schema.schemas["bronze"].name
  url                 = var.stage.url
  storage_integration = var.stage.storage_integration
  comment             = var.stage.comment
}

# Create Snowpipe for each bronze table

resource "snowflake_pipe" "pipes" {
  for_each = var.table_configs

  name     = "${var.environment}_${each.value.table_name}_pipe"
  database = var.snowflake_database
  schema   = snowflake_schema.schemas["bronze"].name

  auto_ingest = true

  copy_statement = <<EOT
  COPY INTO "${var.snowflake_database}"."${snowflake_schema.schemas["bronze"].name}"."${var.environment}_${each.value.table_name}"
  FROM @"${snowflake_stage.bronze_stage.database}"."${snowflake_stage.bronze_stage.schema}"."${snowflake_stage.bronze_stage.name}"/${each.value.table_name}/
  FILE_FORMAT = (TYPE = 'CSV', SKIP_HEADER = 1)
  ON_ERROR = 'CONTINUE';
  EOT

  depends_on = [
    snowflake_table.bronze_table,
    snowflake_stage.bronze_stage,
    snowflake_schema.schemas
  ]
}

# S3 Bucket for data landing
data "aws_s3_bucket" "ecommerce_data" {
  bucket = var.s3_bucket_name
}

# S3 Bucket Notification Configuration using Snowpipe notification channels
resource "aws_s3_bucket_notification" "snowflake_notifications" {
  bucket = data.aws_s3_bucket.ecommerce_data.id

  dynamic "queue" {
    for_each = var.table_configs
    content {
      queue_arn     = snowflake_pipe.pipes[queue.key].notification_channel
      events        = ["s3:ObjectCreated:*"]
      filter_prefix = "ecommerce-raw/${queue.value.table_name}/"
      filter_suffix = ".csv"
    }
  }

  depends_on = [snowflake_pipe.pipes]
}

