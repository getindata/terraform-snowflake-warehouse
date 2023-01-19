locals {
  name_from_descriptor = module.warehouse_label.enabled ? trim(replace(
    lookup(module.warehouse_label.descriptors, var.descriptor_name, module.warehouse_label.id), "/${module.warehouse_label.delimiter}${module.warehouse_label.delimiter}+/", module.warehouse_label.delimiter
  ), module.warehouse_label.delimiter) : null

  enabled              = module.this.enabled
  create_default_roles = local.enabled && var.create_default_roles

  default_roles_definition = {
    usage = {
      warehouse_grants = ["USAGE", "OPERATE"]
    }
    monitor = {
      warehouse_grants = ["MONITOR"]
    }
    admin = {
      warehouse_grants = ["MODIFY", "MONITOR", "USAGE", "OPERATE", "OWNERSHIP"]
    }
  }

  provided_roles = { for role_name, role in var.roles : role_name => {
    for k, v in role : k => v
    if v != null
  } }
  roles_definition = module.roles_deep_merge.merged

  default_roles = {
    for role_name, role in local.roles_definition : role_name => role
    if contains(keys(local.default_roles_definition), role_name)
  }
  custom_roles = {
    for role_name, role in local.roles_definition : role_name => role
    if !contains(keys(local.default_roles_definition), role_name)
  }

  roles = {
    for role_name, role in merge(
      module.snowflake_default_role,
      module.snowflake_custom_role
    ) : role_name => role
    if role.name != null
  }
}

module "roles_deep_merge" {
  source  = "Invicton-Labs/deepmerge/null"
  version = "0.1.5"

  maps = [local.default_roles_definition, local.provided_roles]
}
