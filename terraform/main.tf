# Snowflake Infrastructure Module
module "snowflake" {
  source = "./modules/snowflake"

  environment        = var.environment
  snowflake_database = var.snowflake_database
  schemas            = local.schemas
  table_configs      = local.table_configs
  stage              = local.stage
  s3_bucket_name     = "ecommerce-data-ww"
  raw_prefix         = "ecommerce-raw"
  file_suffix        = ".parquet"

}