context_templates = {
  snowflake-role              = "{{.environment}}_{{.name}}"
  snowflake-project-warehouse = "{{.environment}}_{{.project}}_{{.name}}"
  snowflake-warehouse         = "{{.environment}}_{{.name}}"
  snowflake-warehouse-role    = "{{.prefix}}_{{.environment}}_{{.warehouse}}_{{.name}}"
}
