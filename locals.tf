locals {
  name_from_descriptor = trim(replace(
    lookup(module.this.descriptors, "snowflake-warehouse", module.this.id), "/__+/", ""
  ), "_")

  default_roles = var.create_default_roles ? {
    usage = {
      privileges = ["USAGE", "OPERATE"]
    }
    monitor = {
      privileges = ["MONITOR"]
    }
    modify = {
      privileges = ["MODIFY"]
    }
    admin = {
      privileges = ["MODIFY", "MONITOR", "USAGE", "OPERATE"]
    }
  } : {}

  roles = module.roles_deep_merge.merged
}

module "roles_deep_merge" {
  source  = "Invicton-Labs/deepmerge/null"
  version = "0.1.5"

  maps = [local.default_roles, var.roles]
}
