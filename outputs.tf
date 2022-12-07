output "warehouse" {
  description = "Details of the warehouse"
  value       = one(resource.snowflake_warehouse.this[*])
}

output "roles" {
  description = "Functional roles created for warehouse"
  value       = module.snowflake_role
}
