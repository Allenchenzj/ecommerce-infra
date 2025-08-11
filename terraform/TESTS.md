# Terraform Tests Documentation

This document describes all the Terraform tests in the ecommerce infrastructure project and their purposes.

## Overview

The test suite validates the Snowflake module functionality using Terraform's native testing framework. Tests are organized into focused test files that validate specific aspects of the infrastructure.

## Test Environment Setup

All tests use `environment = "test"` to create test-specific resources with prefixed names (e.g., `test_ecommerce_bronze` instead of `dev_ecommerce_bronze`). This prevents conflicts with existing development resources.

## Test Files

### 1. `module_outputs.tftest.hcl`
**Purpose**: Validates module outputs and basic resource structure

**Command Types**: Mixed (`plan` and `apply`)

**Test Runs**:
- **`test_schema_outputs`** (`command = plan`)
  - Validates 3 schemas are output
  - Checks schema names: `test_ecommerce_bronze`, `test_ecommerce_silver`, `test_ecommerce_gold`

- **`test_table_outputs`** (`command = apply`)
  - Validates exactly 2 bronze tables are created
  - Checks table keys exist: `categories`, `suppliers`
  - Validates table schema assignment

- **`test_stage_output`** (`command = apply`)
  - Validates bronze stage creation with correct name: `test_ecommerce_stage`
  - Checks S3 URL: `s3://ecommerce-data-ww/ecommerce-raw/`
  - Validates storage integration: `S3_INT_ECOMMERCE`
  - Confirms stage is in bronze schema

### 2. `pipe_notifications.tftest.hcl`
**Purpose**: Tests Snowpipe creation and SQS notification channels

**Command Types**: All `apply` (requires actual resource creation)

**Test Runs**:
- **`test_pipe_outputs`**
  - Validates exactly 2 Snowpipes are created
  - Checks pipe keys exist: `categories`, `orders`

- **`test_pipe_naming`**
  - Validates pipe names: `test_categories_pipe`, `test_orders_pipe`

- **`test_pipe_notification_channels`**
  - Validates pipes have notification channels
  - Checks notification channels start with `arn:aws:sqs:`

- **`test_pipe_configuration`**
  - Validates `auto_ingest = true` on pipes
  - Checks pipes are in correct schema: `test_ecommerce_bronze`
  - Validates pipes are in correct database

### 3. `s3_integration_working.tftest.hcl`
**Purpose**: Tests S3 integration components that work in test context

**Command Types**: `plan` only

**Test Runs**:
- **`validate_s3_integration_components`**
  - Validates bronze stage exists for S3 integration
  - Checks stage URL configuration
  - Validates storage integration is configured

### 4. `s3_validation.tftest.hcl`
**Purpose**: Validates S3 integration through Snowpipe configuration

**Command Types**: `apply` (requires pipe creation for notification channels)

**Test Runs**:
- **`validate_pipe_integration`**
  - Validates all pipes have notification channels (required for S3 events)
  - Checks `auto_ingest = true` on all pipes (required for S3 processing)
  - Validates pipes exist for each expected table
  - Confirms bronze stage has S3 URL for integration

### 5. `snowflake_integration.tftest.hcl`
**Purpose**: Tests basic Snowflake resource creation and integration

**Command Types**: `plan` only

**Test Runs**:
- **`validate_snowflake_resources`**
  - Validates core Snowflake resources are properly configured
  - Tests resource relationships and dependencies

### 6. `yaml_parsing.tftest.hcl`
**Purpose**: Tests YAML configuration parsing and schema definitions

**Command Types**: `plan` only

**Test Runs**:
- **`test_yaml_parsing`**
  - Validates YAML files in `table-configs/` are properly parsed
  - Checks table configuration structure

- **`test_yaml_content_validation`**
  - Validates YAML content meets expected schema
  - Checks required fields are present

- **`test_schema_definitions`**
  - Validates schema definitions from locals
  - Checks schema structure and naming

## Test Execution

### Running All Tests
```bash
terraform test -var-file="env/test/test.tfvars" 
```

### Running Specific Test File
```bash
terraform test -filter=module_outputs.tftest.hcl
```

## Test Architecture

### Environment Isolation
- Tests use `environment = "test"` variable
- All resources get `test_` prefix to avoid conflicts
- Test resources are automatically cleaned up after each run

### Resource Naming Convention
- **Schemas**: `test_ecommerce_{layer}` (e.g., `test_ecommerce_bronze`)
- **Tables**: `test_{table_name}` (e.g., `test_orders`)
- **Stages**: `test_{stage_name}` (e.g., `test_ecommerce_stage`)
- **Pipes**: `test_{table_name}_pipe` (e.g., `test_orders_pipe`)

### Test Data Sources
- **YAML Configurations**: Tests use actual YAML files from `table-configs/`
- **Local Values**: Tests validate computed locals from `locals.tf`
- **Module Outputs**: Tests validate all module outputs from `modules/snowflake/outputs.tf`

## Test Coverage

### ✅ Covered Areas
- Module output validation
- Resource creation and naming
- Schema and table configuration
- Snowpipe creation and configuration
- S3 integration setup
- YAML configuration parsing
- Environment-based resource isolation

### 🔄 Areas for Future Testing
- Data loading workflows
- Transformation pipeline testing
- Performance testing
- Error handling scenarios
- Cross-environment resource validation

## Troubleshooting

### Common Issues
1. **"Unknown condition value" errors**: Use `command = apply` for tests that need actual resource attributes
2. **Resource conflicts**: Ensure tests use `environment = "test"` variable
3. **Timeout issues**: Some tests may take time due to Snowflake resource creation

### Debug Tips
- Use `terraform test -verbose` for detailed output
- Check individual test runs with specific filters
- Validate YAML files independently if parsing tests fail

## Test Maintenance

### When to Update Tests
- Adding new tables to `table-configs/`
- Modifying module outputs
- Changing resource naming conventions
- Adding new infrastructure components

### Best Practices
- Keep tests focused and single-purpose
- Use `plan` for validation, `apply` for integration
- Maintain environment isolation
- Document test purposes clearly
- Regular test execution in CI/CD pipeline