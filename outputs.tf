output "warehouse" {
  description = "Details of the warehouse"
  value       = one(resource.snowflake_warehouse.this[*])
}

output "roles" {
  description = "Access roles created for warehouse"
  value       = local.roles
}
