locals {
  context_template = lookup(var.context_templates, var.name_scheme.context_template_name, null)

  default_role_naming_scheme = {
    properties            = ["prefix", "environment", "warehouse", "name"]
    context_template_name = "snowflake-warehouse-role"
    extra_values = {
      prefix    = "whs"
      warehouse = var.name
    }
  }

  default_roles_definition = {
    usage = {
      comment       = null
      granted_roles = []
      warehouse_grants = {
        all_privileges    = null
        privileges        = ["USAGE", "OPERATE"]
        with_grant_option = false
      }
    },
    monitor = {
      comment       = null
      granted_roles = []
      warehouse_grants = {
        privileges        = ["MONITOR"]
        all_privileges    = null
        with_grant_option = false
      }
    },
    admin = {
      comment       = null
      granted_roles = []
      warehouse_grants = {
        all_privileges    = true
        privileges        = null
        with_grant_option = false
      }
    }
  }

  provided_roles = { for role_name, role in var.roles : role_name => {
    for k, v in role : k => v
    if v != null
  } }
  roles_definition = module.roles_deep_merge.merged

  default_roles = {
    for role_name, role in local.roles_definition : role_name => role
    if contains(keys(local.default_roles_definition), role_name) && var.create_default_roles
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
    if role_name != null
  }
}

module "roles_deep_merge" {
  source  = "Invicton-Labs/deepmerge/null"
  version = "0.1.5"

  maps = [local.default_roles_definition, local.provided_roles]
}
