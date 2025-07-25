locals {
  # Define the schemas for different data processing stages
  schemas = {
    "bronze" = {
      name = "ecommerce_bronze"
      # database = "ECOMMERCE_DB_YL"
      comment = "Bronze schema for raw data"
    },
    "silver" = {
      name = "ecommerce_silver"
      # database = "ECOMMERCE_DB_YL"
      comment = "Silver schema for processed data"
    }
    "gold" = {
      name = "ecommerce_gold"
      # database = "ECOMMERCE_DB_YL"
      comment = "Gold schema for aggregated data"
    }
  }

  # Read YAML table configurations dynamically
  # Path is relative to deployment/terraform directory (same level as locals.tf)
  table_config_files = fileset("${path.module}/table_config", "*.yaml")

  # Parse YAML configurations for dynamic table creation
  table_configs = {
    for filename in local.table_config_files :
    trimsuffix(filename, ".yaml") => yamldecode(file("${path.module}/table_config/${filename}"))
  }

  stage = {
    name                = "ecommerce_stage"
    comment             = "Stage for user data from S3 landing zone"
    url                 = "s3://ecommerce-data-ww/ecommerce-raw/"
    storage_integration = "S3_INT_ECOMMERCE" # case sensitive
  }
}