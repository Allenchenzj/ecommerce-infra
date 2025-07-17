environment = "dev"
stage_name  = "ecommerce_raw_stage"
stage_database = "ECOMMERCE_DB_YL" 
stage_schema = "ecommerce_bronze" # case matters
stage_url = "s3://ecommerce-data-ww/ecommerce-raw/"
storage_integration = "S3_INT_ECOMMERCE" # case matters
s3_bucket_name = "ecommerce-data-ww"
notification_channel = "arn:aws:sqs:ap-southeast-2:184862803517:sf-snowpipe-AIDASWCVOQY6VWWA4OCZL-yQZRTtgnnAp-RlB6kf0i0g"
