module "warehouse_label" {
  source  = "cloudposse/label/null"
  version = "0.25.0"
  context = module.this.context

  delimiter           = coalesce(module.this.context.delimiter, "_")
  regex_replace_chars = coalesce(module.this.context.regex_replace_chars, "/[^_a-zA-Z0-9]/")
  label_value_case    = coalesce(module.this.context.label_value_case, "upper")
}

resource "snowflake_warehouse" "this" {
  count = module.this.enabled ? 1 : 0

  name    = local.name_from_descriptor
  comment = var.comment

  warehouse_size = var.warehouse_size
  warehouse_type = var.warehouse_type

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

module "snowflake_default_role" {
  for_each = local.default_roles

  source  = "getindata/role/snowflake"
  version = "1.0.3"
  context = module.this.context

  name            = each.key
  attributes      = ["WHS", one(snowflake_warehouse.this[*].name)]
  enabled         = local.create_default_roles && lookup(each.value, "enabled", true)
  descriptor_name = lookup(each.value, "descriptor_name", "snowflake-role")

  role_ownership_grant = lookup(each.value, "role_ownership_grant", "SYSADMIN")
  granted_to_users     = lookup(each.value, "granted_to_users", [])
  granted_to_roles     = lookup(each.value, "granted_to_roles", [])
  granted_roles        = lookup(each.value, "granted_roles", [])
}

module "snowflake_custom_role" {
  for_each = local.custom_roles

  source  = "getindata/role/snowflake"
  version = "1.0.3"
  context = module.this.context

  name            = each.key
  attributes      = ["WHS", one(snowflake_warehouse.this[*].name)]
  enabled         = local.create_default_roles && lookup(each.value, "enabled", true)
  descriptor_name = lookup(each.value, "descriptor_name", "snowflake-role")

  role_ownership_grant = lookup(each.value, "role_ownership_grant", "SYSADMIN")
  granted_to_users     = lookup(each.value, "granted_to_users", [])
  granted_to_roles     = lookup(each.value, "granted_to_roles", [])
  granted_roles        = lookup(each.value, "granted_roles", [])
}

resource "snowflake_warehouse_grant" "this" {
  for_each = local.enabled ? transpose({ for role_name, role in local.roles : local.roles[role_name].name =>
    lookup(local.roles_definition[role_name], "warehouse_grants", [])
    if lookup(local.roles_definition[role_name], "enabled", true)
  }) : {}
  warehouse_name = one(resource.snowflake_warehouse.this[*]).name
  privilege      = each.key
  roles          = each.value

  # Whole configuration should be maintained "as Code" so below
  # options should be disabled in all use-cases
  enable_multiple_grants = false
  with_grant_option      = false
}
