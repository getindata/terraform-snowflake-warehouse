module "terraform_snowflake_warehouse" {
  source  = "../../"
  context = module.this.context

  enabled = true

  name = "minimal_warehouse"
}
