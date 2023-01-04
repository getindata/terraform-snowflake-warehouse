locals {
  name_from_descriptor = module.warehouse_label.enabled ? trim(replace(
    lookup(module.warehouse_label.descriptors, var.descriptor_name, module.warehouse_label.id), "/${module.warehouse_label.delimiter}${module.warehouse_label.delimiter}+/", module.warehouse_label.delimiter
  ), module.warehouse_label.delimiter) : null

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
