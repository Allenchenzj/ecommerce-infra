import os
import logging
from utils.config_loader import load_config
from utils.S3SchemaHandler import S3SchemaHandler

logging.basicConfig(level=logging.INFO, format='%(levelname)s: %(message)s')
logger=logging.getLogger(__name__)

def main():
    config = load_config("config/config.yml")
    bucket = config["s3"]["bucket"]
    prefix = config["s3"]["prefix"]
    ddl_dir = config["output"]["ddl_dir"]

    logger.info(f"Connecting to S3 bucket: {bucket} with prefix: {prefix}")
    handler=S3SchemaHandler(bucket,prefix)

    tables = handler.list_subfolders()
    if not tables:
        logger.warning("No tables found under prefix.")
        return

    for table_name in tables:
        table_prefix = f"{prefix}/{table_name}"
        logger.info(f"\n Processing table: {table_name} (s3://{bucket}/{table_prefix}/)")
        handler.prefix = table_prefix  # update prefix to point to table-specific folder

        parquet_paths = handler.get_all_parquet_paths()
        if not parquet_paths:
            logger.warning(f"No parquet files found for table {table_name}. Skipping.")
            continue
              
        base_schema = handler.get_parquet_schema(s3_uri=parquet_paths[0]) 
        if base_schema is None:
            logger.error(f"Failed to read schema from first parquet file for table {table_name}. Skipping.")
            continue

        # check & merge schema
        for path in parquet_paths[1:]:
            schema = handler.get_parquet_schema(s3_uri=path)
            if schema != base_schema:
                logger.warning(f"Schema mismatch found in file: {path}. Merging schema.")
                base_schema = handler.merge_schemas(base_schema=base_schema, new_schema=schema)

        yaml_dir = "../terraform/table_config"
        os.makedirs(yaml_dir, exist_ok=True)
        yaml_path = os.path.join(yaml_dir, f"{table_name}.yaml")

        handler.generate_yaml(table_name=table_name, schema=base_schema, output_path=yaml_path)

        logger.info(f"✅ YAML generated for table '{table_name}': {yaml_path}")

if __name__ == "__main__":
    main()
