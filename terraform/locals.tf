locals {
  # Define the schemas for different data processing stages
  schemas = {
    bronze = {
      name    = "ecommerce_bronze"
      comment = "Bronze layer for raw data"
    }
    silver = {
      name    = "ecommerce_silver"
      comment = "Silver layer for transformed data"
    }
    gold = {
      name    = "ecommerce_gold"
      comment = "Gold layer for business ready data"
    }
  }

  # Read YAML table configurations dynamically
  # Path is relative to deployment/terraform directory (same level as locals.tf)
  table_config_files = fileset("${path.module}/table-configs", "*.yml")

  # Parse YAML configurations for dynamic table creation
  table_configs = {
    for file in local.table_config_files :
    trimsuffix(file, ".yml") => yamldecode(file("${path.module}/table-configs/${file}"))
  }

  stage = {
    name                = "ecommerce_stage"
    comment             = "Stage for user data from S3 landing zone"
    url                 = "s3://ecommerce-data-ww/ecommerce-raw/"
    storage_integration = "S3_INT_ECOMMERCE"
  }

}

