# ecommerce-infra
This repo is for the ecommerce data platform project as the infrastructure management repo

# Grant permission to the terraform role 
GRANT USAGE ON DATABASE ECOMMERENCE_DB_AC TO ROLE TERRAFORM_IAC;
GRANT CREATE SCHEMA ON DATABASE ECOMMERENCE_DB_AC TO ROLE TERRAFORM_IAC;
GRANT USAGE ON INTEGRATION s3_int_ecommerce TO ROLE TERRAFORM_IAC;