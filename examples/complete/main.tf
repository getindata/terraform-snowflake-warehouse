/*
* # Complete example for Snowflake Warehouse module
*/

resource "snowflake_account_role" "this_admin" {
  name    = "WAREHOUSE_ADMIN"
  comment = "Role for Snowflake Administrators"
}

resource "snowflake_account_role" "this_dev" {
  name    = "WAREHOUSE_DEV"
  comment = "Role for Snowflake Developers"
}

resource "snowflake_resource_monitor" "this" {
  name         = "WAREHOUSE_RM"
  credit_quota = 20

  notify_triggers = [50, 100]
}

module "terraform_snowflake_warehouse_1" {
  source = "../../"

  name    = "full_warehouse"
  comment = "My Warehouse"

  context_templates = var.context_templates

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
      granted_to_roles = [snowflake_account_role.this_admin.name]
    }
    custom_role = {
      warehouse_grants = {
        privileges = ["USAGE", "MODIFY"]
      }
      granted_to_roles = [snowflake_account_role.this_dev.name]
    }
  }
}

module "terraform_snowflake_warehouse_2" {
  source = "../../"

  name = "sample_warehouse_2"
  name_scheme = {
    context_template_name = "snowflake-project-warehouse"
    extra_values = {
      project = "project"
    }
    uppercase = false
  }
  context_templates = var.context_templates

  create_default_roles = true
}


module "terraform_snowflake_warehouse_3" {
  source = "../../"

  name = "sample_warehouse_3"
  name_scheme = {
    properties = ["prefix", "project", "name"]
    extra_values = {
      prefix  = "custom"
      project = "project"
    }
  }

  generation = "2"

  create_default_roles = false
}
