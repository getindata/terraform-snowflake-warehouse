output "warehouse" {
  description = "Details of the warehouse"
  value       = one(resource.snowflake_warehouse.this[*])
}
