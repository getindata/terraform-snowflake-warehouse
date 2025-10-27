# AGENTS.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Module Overview

This is a Terraform module for Snowflake Warehouse management that:
- Creates Snowflake warehouses with comprehensive configuration options
- Manages role-based access control through default and custom roles
- Uses CloudPosse context provider for flexible naming conventions
- Integrates with getindata/role/snowflake module (v4.0.0) for role management

## Architecture

### Naming Convention System

The module uses CloudPosse context provider instead of deprecated `context.tf` (nulllabel):

1. **Context Provider Setup**: The `data.context_label.this` data source generates resource names based on templates
2. **Template Resolution**: `context_templates` variable defines naming patterns (e.g., `{{.environment}}_{{.name}}`)
3. **Name Scheme Configuration**: Each resource has configurable `name_scheme` with properties, delimiter, and template selection
4. **Template Lookup**: `local.context_template` resolves which template to use from `var.context_templates`

Key files:
- [locals.tf:1-3](locals.tf#L1-L3) - Template resolution logic
- [main.tf:1-12](main.tf#L1-L12) - Context label data source usage

### Role Management Architecture

The module creates two types of roles through a merge-and-split pattern:

1. **Default Roles** ([locals.tf:14-42](locals.tf#L14-L42)): Pre-defined functional roles (admin, usage, monitor)
2. **Custom Roles** ([locals.tf:44-47](locals.tf#L44-L47)): User-provided roles via `var.roles`
3. **Deep Merge** ([locals.tf:68-73](locals.tf#L68-L73)): Uses `Invicton-Labs/deepmerge/null` to merge default + provided roles
4. **Split Logic** ([locals.tf:50-57](locals.tf#L50-L57)): Separates merged roles into default vs custom for different module calls

Role modules are instantiated separately:
- [main.tf:44-71](main.tf#L44-L71) - Default roles module
- [main.tf:73-100](main.tf#L73-L100) - Custom roles module

### Resource Structure

- **Primary Resource**: `snowflake_warehouse.this` ([main.tf:14-39](main.tf#L14-L39))
- **Role Grants**: Handled by nested `getindata/role/snowflake` modules with `account_objects_grants`
- **State Migration**: `moved` block at [main.tf:40-43](main.tf#L40-L43) handles v2 to v3 upgrade

## Common Commands

### Development Workflow

```bash
# Initialize module
terraform init

# Validate configuration
terraform validate

# Format code
terraform fmt -recursive

# Run pre-commit hooks (validates, formats, lints, generates docs, security scan)
pre-commit install
pre-commit run --all-files
```

### Testing with Examples

```bash
# Simple example
cd examples/simple
make init
make plan
make apply

# Complete example (full configuration)
cd examples/complete
make init
make plan
make apply
```

### Documentation Generation

```bash
# Auto-generate README inputs/outputs tables
terraform-docs .
```

## Pre-commit Configuration

The module uses pre-commit hooks in this order:
1. `terraform-validate` - Must run first (performs `terraform init` required by tflint)
2. `terraform-fmt` - Code formatting
3. `tflint` - Terraform linting
4. `terraform-docs` - Auto-generates documentation
5. `checkov` - Security scanning (skips CKV_TF_1 for module sources)

## Provider Version Requirements

- **Snowflake Provider**: `>= 2.7` (snowflakedb/snowflake)
- **Context Provider**: `>= 0.4.0` (cloudposse/context)
- **Terraform**: `>= 1.3`

**IMPORTANT**: ALWAYS use `snowflakedb/snowflake` provider. NEVER use `Snowflake-Labs/snowflake` provider. The Snowflake-Labs provider is deprecated and should not be used in any configuration or documentation queries.

## Breaking Changes

### v3.x Migration
- Removed `context.tf` (nulllabel) - switched to context provider
- Removed variables: `context`, `enabled`, `environment`, `namespace`, `tenant`, `stage`, `attributes`, `delimiter`, `tags`, `labels_as_tags`, etc.
- Added: `context_templates` and `name_scheme` variables
- State migration handled via `moved` blocks

### v4.x Migration
- Provider source changed from `Snowflake-Labs/snowflake` to `snowflakedb/snowflake`

## Key Variables

### Required
- `name` - Base name for the warehouse resource

### Naming Configuration
- `name_scheme` - Object controlling naming behavior (properties, delimiter, template, regex, uppercase)
- `context_templates` - Map of go-template strings for naming patterns (supersedes name_scheme properties/delimiter)

### Warehouse Configuration

- `warehouse_size`, `warehouse_type` - Warehouse compute settings
- `generation` - Warehouse generation (only for STANDARD warehouses). Valid values: "1" or "2" (string type, not number - this is dictated by the Snowflake provider schema)
- `auto_resume`, `auto_suspend`, `initially_suspended` - Power management
- `min_cluster_count`, `max_cluster_count`, `scaling_policy` - Multi-cluster settings
- `enable_query_acceleration`, `query_acceleration_max_scale_factor` - Query acceleration
- `resource_monitor` - Credit quota monitoring

### Role Management
- `create_default_roles` - Boolean to create admin/usage/monitor roles
- `roles` - Map of role definitions with grants and assignments

## Examples Structure

- **simple/** - Minimal configuration showing basic warehouse creation
- **complete/** - Full-featured example with:
  - Resource monitor integration
  - Default roles enabled
  - Custom role with specific privileges
  - Multiple naming scheme patterns
  - Context template usage
  - Generation 2 warehouse configuration (warehouse_3)

## Important Implementation Notes

### Generation Field

- Type: `string` (not `number`) - this is required by the Snowflake provider schema, not a design choice
- Valid values: `"1"`, `"2"`
- Only applicable to STANDARD warehouse type
- Validation uses ternary operator to handle null: `var.generation == null ? true : contains(["1", "2"], var.generation)`
- Added in provider version 2.7+
- The string type requirement comes from how Snowflake's SQL interface and provider handle this parameter

### Variable Validation Pattern

When validating optional (nullable) variables with `contains()`, use ternary operator to avoid null evaluation errors:

```hcl
validation {
  condition     = var.field == null ? true : contains(["val1", "val2"], var.field)
  error_message = "Invalid value"
}
```

Do NOT use: `var.field == null || contains([...], var.field)` as it will fail when the value is null.
