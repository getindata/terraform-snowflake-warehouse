resource "snowflake_role" "this_admin" {
  name    = "WAREHOUSE_ADMIN"
  comment = "Role for Snowflake Administrators"
}

resource "snowflake_role" "this_dev" {
  name    = "WAREHOUSE_DEV"
  comment = "Role for Snowflake Developers"
}

resource "snowflake_resource_monitor" "this" {
  name         = "WAREHOUSE_RM"
  credit_quota = 20

  notify_triggers = [50, 100]

  set_for_account = false
}

module "terraform_snowflake_warehouse" {
  source  = "../../"
  context = module.this.context

  descriptor_formats = {
    snowflake-role = {
      labels = ["attributes", "name"]
      format = "%v_%v"
    }
    snowflake-warehouse = {
      labels = ["name"]
      format = "%v"
    }
  }

  enabled = true

  name    = "full_warehouse"
  comment = "My Warehouse"

  warehouse_size = "x-small"

  auto_resume         = true
  auto_suspend        = 600
  initially_suspended = true
  min_cluster_count   = 1
  max_cluster_count   = 10
  scaling_policy      = "Economy"

  max_concurrency_level               = 3
  enable_query_acceleration           = true
  query_acceleration_max_scale_factor = 2

  statement_timeout_in_seconds        = 300
  statement_queued_timeout_in_seconds = 600

  resource_monitor = snowflake_resource_monitor.this.name

  create_default_roles = true

  roles = {
    admin = {
      granted_to_roles = [snowflake_role.this_admin.name]
    }
    custom_role = {
      privileges       = ["USAGE", "MODIFY"]
      granted_to_roles = [snowflake_role.this_dev.name]
    }
  }
}
