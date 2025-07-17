locals {
  schemas = {
    "ecommerce_bronze" = { 
      name     = "ecommerce_bronze"
      database = "ECOMMERCE_DB_YL"
      comment  = "Bronze schema for raw data"
    },
    "ecommerce_silver" = {
      name     = "ecommerce_silver"
      database = "ECOMMERCE_DB_YL"
      comment  = "Silver schema for processed data"
    }
    "Eecommerce_gold" = {
      name     = "ecommerce_gold"
      database = "ECOMMERCE_DB_YL"
      comment  = "Gold schema for aggregated data"
    }
  }

  table_files = fileset("${path.module}/table_config", "*.yaml")

  tables = {
    for filename in local.table_files :
    trimsuffix(basename(filename), ".yaml") => yamldecode(
      file("${path.module}/table_config/${filename}")
    )
  }
}
 