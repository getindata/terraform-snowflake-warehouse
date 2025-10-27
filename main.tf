data "context_label" "this" {
  delimiter  = local.context_template == null ? var.name_scheme.delimiter : null
  properties = local.context_template == null ? var.name_scheme.properties : null
  template   = local.context_template

  replace_chars_regex = var.name_scheme.replace_chars_regex

  values = merge(
    var.name_scheme.extra_values,
    { name = var.name }
  )
}

resource "snowflake_warehouse" "this" {
  name    = var.name_scheme.uppercase ? upper(data.context_label.this.rendered) : data.context_label.this.rendered
  comment = var.comment

  warehouse_size = var.warehouse_size
  warehouse_type = var.warehouse_type
  generation     = var.generation

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
moved {
  from = snowflake_warehouse.this[0]
  to   = snowflake_warehouse.this
}

module "snowflake_default_role" {
  for_each = local.default_roles #{ for role_name, role in local.default_roles : role_name => role if var.create_default_roles }

  source  = "getindata/role/snowflake"
  version = "4.0.0"

  context_templates = var.context_templates

  name = each.key
  name_scheme = merge(
    local.default_role_naming_scheme,
    lookup(each.value, "name_scheme", {})
  )

  role_ownership_grant = lookup(each.value, "role_ownership_grant", "SYSADMIN")
  granted_to_users     = lookup(each.value, "granted_to_users", [])
  granted_to_roles     = lookup(each.value, "granted_to_roles", [])
  granted_roles        = lookup(each.value, "granted_roles", [])

  account_objects_grants = {
    WAREHOUSE = [{
      all_privileges    = each.value.warehouse_grants.all_privileges
      privileges        = each.value.warehouse_grants.privileges
      with_grant_option = each.value.warehouse_grants.with_grant_option
      object_name       = snowflake_warehouse.this.name
    }]
  }
}

module "snowflake_custom_role" {
  for_each = local.custom_roles

  source  = "getindata/role/snowflake"
  version = "4.0.0"

  context_templates = var.context_templates

  name = each.key
  name_scheme = merge(
    local.default_role_naming_scheme,
    lookup(each.value, "name_scheme", {})
  )

  role_ownership_grant = lookup(each.value, "role_ownership_grant", "SYSADMIN")
  granted_to_users     = lookup(each.value, "granted_to_users", [])
  granted_to_roles     = lookup(each.value, "granted_to_roles", [])
  granted_roles        = lookup(each.value, "granted_roles", [])

  account_objects_grants = {
    WAREHOUSE = [{
      all_privileges    = each.value.warehouse_grants.all_privileges
      privileges        = each.value.warehouse_grants.privileges
      with_grant_option = each.value.warehouse_grants.with_grant_option
      object_name       = snowflake_warehouse.this.name
    }]
  }
}
