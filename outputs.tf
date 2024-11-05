output "warehouse" {
  description = "Details of the warehouse"
  value = {
    name                                = snowflake_warehouse.this.name
    fully_qualified_name                = snowflake_warehouse.this.fully_qualified_name
    comment                             = snowflake_warehouse.this.comment
    warehouse_type                      = snowflake_warehouse.this.warehouse_type
    warehouse_size                      = snowflake_warehouse.this.warehouse_size
    auto_resume                         = snowflake_warehouse.this.auto_resume
    auto_suspend                        = snowflake_warehouse.this.auto_suspend
    initially_suspended                 = snowflake_warehouse.this.initially_suspended
    min_cluster_count                   = snowflake_warehouse.this.min_cluster_count
    max_cluster_count                   = snowflake_warehouse.this.max_cluster_count
    scaling_policy                      = snowflake_warehouse.this.scaling_policy
    max_concurrency_level               = snowflake_warehouse.this.max_concurrency_level
    enable_query_acceleration           = snowflake_warehouse.this.enable_query_acceleration
    query_acceleration_max_scale_factor = snowflake_warehouse.this.query_acceleration_max_scale_factor
    statement_timeout_in_seconds        = snowflake_warehouse.this.statement_timeout_in_seconds
    statement_queued_timeout_in_seconds = snowflake_warehouse.this.statement_queued_timeout_in_seconds
    resource_monitor                    = snowflake_warehouse.this.resource_monitor
  }
}

output "roles" {
  description = "Access roles created for warehouse"
  value       = local.roles
}
