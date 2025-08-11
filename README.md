# ecommerce-infra
This repo is for the ecommerce data platform project as the infrastructure management repo

# Grant permission to the terraform role
GRANT USAGE ON DATABASE ECOMMERENCE_DB_YL TO ROLE TERRAFORM_IAC;
GRANT CREATE SCHEMA ON DATABASE ECOMMERENCE_DB_YL TO ROLE TERRAFORM_IAC;
GRANT USAGE ON INTEGRATION s3_int_ecommerce TO ROLE TERRAFORM_IAC;

# Create dynamodb table for tf state lock
  aws dynamodb create-table \
    --table-name terraform-lock \
    --attribute-definitions AttributeName=LockID,AttributeType=S \
    --key-schema AttributeName=LockID,KeyType=HASH \
    --billing-mode PAY_PER_REQUEST \
    --region ap-southeast-2
