# Snowflake Infrastructure Module
module "snowflake" {
  source = "./modules/snowflake"

  snowflake_database = var.snowflake_database
  environment        = var.environment
  schemas            = local.schemas
  table_configs      = local.table_configs
  stage              = local.stage
  s3_bucket_name     = "ecommerce-data-ww"
}