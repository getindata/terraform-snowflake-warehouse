resource "snowflake_warehouse" "this" {
  count = module.this.enabled ? 1 : 0

  name    = local.name_from_descriptor
  comment = var.comment

  warehouse_size = var.warehouse_size

  auto_resume         = var.auto_resume
  auto_suspend        = var.auto_suspend
  initially_suspended = var.initially_suspended

  min_cluster_count = var.min_cluster_count
  max_cluster_count = var.max_cluster_count
  scaling_policy    = var.scaling_policy

  max_concurrency_level = var.max_concurrency_level

  enable_query_acceleration           = var.enable_query_acceleration
  query_acceleration_max_scale_factor = var.query_acceleration_max_scale_factor

  statement_queued_timeout_in_seconds = var.statement_queued_timeout_in_seconds
  statement_timeout_in_seconds        = var.statement_timeout_in_seconds

  resource_monitor = var.resource_monitor
}

module "snowflake_role" {
  for_each = local.roles

  source  = "github.com/getindata/terraform-snowflake-role"
  context = module.this.context
  enabled = module.this.enabled && lookup(each.value, "enabled", true)

  name       = each.key
  attributes = ["WHS", one(snowflake_warehouse.this[*].name)]

  granted_to_users = lookup(each.value, "granted_to_users", [])
  granted_to_roles = lookup(each.value, "granted_to_roles", [])
  granted_roles    = lookup(each.value, "granted_roles", [])
}

resource "snowflake_warehouse_grant" "this" {
  for_each = module.this.enabled ? transpose(
    {
      for role_name, role in module.snowflake_role : module.snowflake_role[role_name].name =>
      local.roles[role_name].privileges if lookup(local.roles[role_name], "enabled", true)
    }
  ) : {}
  warehouse_name = one(resource.snowflake_warehouse.this[*]).name
  privilege      = each.key
  roles          = each.value

  # Whole configuration should be maintained "as Code" so below
  # options should be disabled in all use-cases
  enable_multiple_grants = false
  with_grant_option      = false
}
