import os
import yaml
import boto3
import logging
import snowflake.connector

# ---------------------- Configuration ----------------------

AWS_REGION = 'ap-southeast-2'
SECRET_ID = 'snowflake/ecommerce/credentials_yl'
TABLE_CONFIG_DIR = '../terraform/table_config'
STAGE_NAME = 'production_ecommerce_stage'           # External stage name in Snowflake
SCHEMA_NAME = 'production_ecommerce_bronze'         # Target schema name (case-sensitive in Snowflake)
DATABASE_NAME = 'ECOMMERCE_DB_YL'         # Target database name in Snowflake

# ---------------------- Logging Setup ----------------------

logging.basicConfig(
    level=logging.INFO,
    format='[%(levelname)s] %(message)s',
    handlers=[logging.StreamHandler()]
)

# ---------------------- Secrets Manager ----------------------

logging.info("Fetching Snowflake credentials from AWS Secrets Manager")
secrets_client = boto3.client('secretsmanager', region_name=AWS_REGION)
secret_value = secrets_client.get_secret_value(SecretId=SECRET_ID)
credentials = yaml.safe_load(secret_value['SecretString'])

# ---------------------- Snowflake Connection ----------------------

logging.info("Connecting to Snowflake")
conn = snowflake.connector.connect(
    user=credentials['snowflake_username'],
    password=credentials['snowflake_password'],
    account=f"{credentials['snowflake_organization_name']}-{credentials['snowflake_account_name']}",
    warehouse=credentials['snowflake_warehouse'],
    role=credentials['snowflake_role'],
    database=DATABASE_NAME,
    schema=SCHEMA_NAME,
    autocommit=True
)

# ---------------------- Data Loading Loop ----------------------

try:
    logging.info("Starting bulk data load for all table configs")
    for filename in os.listdir(TABLE_CONFIG_DIR):
        if filename.endswith('.yaml'):
            file_path = os.path.join(TABLE_CONFIG_DIR, filename)

            with open(file_path, 'r', encoding='utf-8') as f:
                config = yaml.safe_load(f)

            table_name = config.get('name')
            if not table_name:
                logging.warning(f"Skipping '{filename}': missing 'name' field")
                continue

            # Construct COPY INTO statement
            sql = f"""
            COPY INTO "{DATABASE_NAME}"."{SCHEMA_NAME}"."production_{table_name}"
            FROM @"{DATABASE_NAME}"."{SCHEMA_NAME}"."{STAGE_NAME}"/{table_name}/
            FILE_FORMAT = (TYPE = 'PARQUET')
            MATCH_BY_COLUMN_NAME = CASE_INSENSITIVE;
            """

            logging.info(f"Executing COPY INTO for table: production_{table_name}")
            conn.cursor().execute(sql)

    logging.info("✅ All tables processed successfully")

except Exception as e:
    logging.error(f"❌ Error occurred during data load: {e}", exc_info=True)

finally:
    conn.close()
    logging.info("Closed Snowflake connection")