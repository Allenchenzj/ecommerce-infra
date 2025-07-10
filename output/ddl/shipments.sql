CREATE OR REPLACE TABLE shipments (
  shipment_id BIGINT,
  order_id BIGINT,
  method_id BIGINT,
  tracking_number VARCHAR,
  status VARCHAR,
  shipped_at TIMESTAMP_NTZ,
  delivered_at TIMESTAMP_NTZ,
  created_at TIMESTAMP_NTZ
)