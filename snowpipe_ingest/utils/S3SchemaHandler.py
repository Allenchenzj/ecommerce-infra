import boto3
import pyarrow.parquet as pq
import pyarrow.fs as pafs
import logging

logger=logging.getLogger(__name__)

class S3SchemaHandler:
    def __init__(self, bucket, prefix):
        self.bucket=bucket
        self.prefix=prefix
        self.s3=boto3.client("s3")
        if not self.prefix.endswith('/'): # Ensure prefix ends with '/'
            self.prefix += '/'

    def list_subfolders(self):
        paginator = self.s3.get_paginator('list_objects_v2')
        tables = set()

        for page in paginator.paginate(Bucket=self.bucket, Prefix=self.prefix, Delimiter='/'):
            for common_prefix in page.get('CommonPrefixes', []):
                folder = common_prefix.get('Prefix')  # e.g. ecommerce-raw/categories/
                table_name = folder[len(self.prefix):].split('/')[0]  # get first-level directory names
                tables.add(table_name)
        return list(tables)

    def get_all_parquet_paths(self):
        paginator = self.s3.get_paginator('list_objects_v2')

        parquet_files = []

        for page in paginator.paginate(Bucket=self.bucket, Prefix=self.prefix):
            for obj in page.get('Contents', []):
                key = obj['Key']
                if key.endswith('.parquet'):
                    parquet_files.append(f"s3://{self.bucket}/{key}")
        return parquet_files

    def get_parquet_schema(self, s3_uri):
        try:
            s3_fs = pafs.S3FileSystem()
            with s3_fs.open_input_file(s3_uri[5:]) as f:
                table = pq.read_table(f)
                return table.schema
        except Exception as e:
            logger.error(f"Error reading schema from {s3_uri}: {e}")
            return None

    def merge_schemas(self, base_schema, new_schema):
        base_fields = {field.name: field for field in base_schema}
        new_fields = {field.name: field for field in new_schema}

        for name, field in new_fields.items():
            if name not in base_fields:
                logger.info(f"Adding new column '{name}' to base schema.")
                base_schema = base_schema.append(field)
        return base_schema
        
    def arrow_to_snowflake_type(self, arrow_type):
        arrow_str = str(arrow_type)
        if "int64" in arrow_str:
            return "BIGINT"
        if "int32" in arrow_str:
            return "INT"
        if "string" in arrow_str:
            return "VARCHAR"
        if "timestamp" in arrow_str:
            return "TIMESTAMP_NTZ"
        if "double" in arrow_str or "float64" in arrow_str:
            return "FLOAT"
        if "bool" in arrow_str:
            return "BOOLEAN"
        return "VARIANT"  # default type
    
    def generate_snowflake_ddl(self, table_name, schema):
        ddl = [f"CREATE OR REPLACE TABLE {table_name} ("]
        for field in schema:
            field_name = field.name
            field_type = self.arrow_to_snowflake_type(field.type)
            ddl.append(f"  {field_name} {field_type},")
        ddl[-1] = ddl[-1].rstrip(',')  # remove last comma
        ddl.append(");")
        return "\n".join(ddl)
    
    