#!/bin/bash -eu  
get_secret_value() {
  set +x
  aws secretsmanager get-secret-value \
    --secret-id "$1" \
    --query "SecretString" \
    --output text | tr -d '\r' | tr -d '\n'
}

if [ -z "${SNOWFLAKE_CREDENTIALS:-}" ]; then
  # It seems like Snowflake credentials are not available in the environment
  # so fetch them from the account's Secrets Manager instead!
  SNOWFLAKE_CREDENTIALS=$(get_secret_value "snowflake/ecommerce/credentials_yl")
fi

# terraform reads the json text and populates the matching `snowflake` object in the variables.tf file
export TF_VAR_snowflake="${SNOWFLAKE_CREDENTIALS}"

echo "SNOWFLAKE_CREDENTIALS: $SNOWFLAKE_CREDENTIALS"
