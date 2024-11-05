<!-- BEGIN_TF_DOCS -->
# Complete example for Snowflake Warehouse module



## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_context_templates"></a> [context\_templates](#input\_context\_templates) | A map of context templates used to generate names | `map(string)` | n/a | yes |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_terraform_snowflake_warehouse_1"></a> [terraform\_snowflake\_warehouse\_1](#module\_terraform\_snowflake\_warehouse\_1) | ../../ | n/a |
| <a name="module_terraform_snowflake_warehouse_2"></a> [terraform\_snowflake\_warehouse\_2](#module\_terraform\_snowflake\_warehouse\_2) | ../../ | n/a |
| <a name="module_terraform_snowflake_warehouse_3"></a> [terraform\_snowflake\_warehouse\_3](#module\_terraform\_snowflake\_warehouse\_3) | ../../ | n/a |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_warehouse_1"></a> [warehouse\_1](#output\_warehouse\_1) | Details of Snowflake warehouse |
| <a name="output_warehouse_2"></a> [warehouse\_2](#output\_warehouse\_2) | Details of Snowflake warehouse |
| <a name="output_warehouse_3"></a> [warehouse\_3](#output\_warehouse\_3) | Details of Snowflake warehouse |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_snowflake"></a> [snowflake](#provider\_snowflake) | >= 0.95 |

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5 |
| <a name="requirement_context"></a> [context](#requirement\_context) | >=0.4.0 |
| <a name="requirement_snowflake"></a> [snowflake](#requirement\_snowflake) | >= 0.95 |

## Resources

| Name | Type |
|------|------|
| [snowflake_account_role.this_admin](https://registry.terraform.io/providers/Snowflake-Labs/snowflake/latest/docs/resources/account_role) | resource |
| [snowflake_account_role.this_dev](https://registry.terraform.io/providers/Snowflake-Labs/snowflake/latest/docs/resources/account_role) | resource |
| [snowflake_resource_monitor.this](https://registry.terraform.io/providers/Snowflake-Labs/snowflake/latest/docs/resources/resource_monitor) | resource |
<!-- END_TF_DOCS -->
