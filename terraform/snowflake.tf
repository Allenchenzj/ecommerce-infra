resource "snowflake_schema" "schemas" {
  for_each = local.schemas
  name     = each.value.name
  database = each.value.database
  comment  = each.value.comment
}


resource "snowflake_table" "tables" {
  for_each = local.tables

  database = local.schemas[each.value.schema].database
  schema   = local.schemas[each.value.schema].name
  name     = each.value.name

  dynamic "column" {
    for_each = each.value.columns
    content {
      name    = column.value.name
      type    = column.value.type
      comment = column.value.comment
    }
  }
  depends_on = [snowflake_schema.schemas]
}

resource "snowflake_stage" "raw_stage" {
  name     = var.stage_name
  database = var.stage_database
  schema   = var.stage_schema
  url = var.stage_url
  storage_integration = var.storage_integration

  comment = "Raw data stage for ecommerce project"
  
  depends_on = [snowflake_schema.schemas]
}

# -----------------------------------------------------------
# Phase I: Create Snowflake Pipes with auto_ingest = true
#         This step generates notification_channel ARNs
#         which will be output as pipe_notification_channels
# -------------------------------------------------------------

resource "snowflake_pipe" "pipes" {
  for_each = local.tables

  name     = "${each.value.name}_pipe"
  database = local.schemas[each.value.schema].database
  schema   = local.schemas[each.value.schema].name

  auto_ingest = true

  copy_statement = <<EOT
  COPY INTO ${local.schemas[each.value.schema].database}."${local.schemas[each.value.schema].name}"."${each.value.name}"
  FROM @${var.stage_database}."${var.stage_schema}"."${var.stage_name}"/${each.value.name}/
  FILE_FORMAT = (TYPE = 'PARQUET')
  MATCH_BY_COLUMN_NAME = CASE_INSENSITIVE
  EOT

  depends_on = [
    snowflake_table.tables,
    snowflake_stage.raw_stage
  ]
}

output "pipe_notification_channels" {
  value = {
    for k, pipe in snowflake_pipe.pipes :
    k => pipe.notification_channel
  }
}

# ----------------------------------------------------------------
# Phase II: Use pipe_notification_channels ARN to manually
#           configure the corresponding SQS queue and connect it
#           to the S3 bucket notification
# ----------------------------------------------------------------

resource "aws_sqs_queue" "snowpipe_queue" {
  name = var.sqs_queue_name
}

resource "aws_sqs_queue_policy" "snowpipe_queue_policy" {
  queue_url = aws_sqs_queue.snowpipe_queue.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "s3.amazonaws.com"
        }
        Action = "sqs:SendMessage"
        Resource = aws_sqs_queue.snowpipe_queue.arn
        Condition = {
          ArnLike = {
            "aws:SourceArn" = "arn:aws:s3:::${var.s3_bucket_name}"
          }
        }
      }
    ]
  })
}

resource "aws_s3_bucket_notification" "snowpipe_triggers" {
  bucket = var.s3_bucket_name

  dynamic "queue" {
    for_each = local.tables
    content {
      id            = "${queue.value.name}_trigger"
      queue_arn     = var.notification_channel
      events        = ["s3:ObjectCreated:*"]
      filter_prefix = "${var.raw_prefix}/${queue.value.name}/"
      filter_suffix = var.file_suffix
    }
  }

  depends_on = [
    snowflake_pipe.pipes,
    aws_sqs_queue.snowpipe_queue    
  ]
}

