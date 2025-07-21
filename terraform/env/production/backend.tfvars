bucket         = "ecommerce-tfstate-ww"
key            = "allen/production/terraform.tfstate"
dynamodb_table = "allen-tf-lock-production"
encrypt        = true
region         = "ap-southeast-2"