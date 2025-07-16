CREATE OR REPLACE TABLE customer_addresses (
  address_id BIGINT,
  customer_id BIGINT,
  address_type VARCHAR,
  street_address VARCHAR,
  city VARCHAR,
  state VARCHAR,
  postal_code VARCHAR,
  country VARCHAR,
  is_default BOOLEAN,
  created_at TIMESTAMP_NTZ
);