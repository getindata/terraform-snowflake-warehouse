# Terraform Snowflake Warehouse

<!--- Pick Cloud provider Badge -->
<!---![Azure](https://img.shields.io/badge/azure-%230072C6.svg?style=for-the-badge&logo=microsoftazure&logoColor=white) -->
<!---![Google Cloud](https://img.shields.io/badge/GoogleCloud-%234285F4.svg?style=for-the-badge&logo=google-cloud&logoColor=white) -->
![Snowflake](https://img.shields.io/badge/-SNOWFLAKE-249edc?style=for-the-badge&logo=snowflake&logoColor=white)
![Terraform](https://img.shields.io/badge/terraform-%235835CC.svg?style=for-the-badge&logo=terraform&logoColor=white)

<!--- Replace repository name -->
![License](https://badgen.net/github/license/getindata/terraform-snowflake-warehouse/)
![Release](https://badgen.net/github/release/getindata/terraform-snowflake-warehouse/)

<p align="center">
  <img height="150" src="https://getindata.com/img/logo.svg">
  <h3 align="center">We help companies turn their data into assets</h3>
</p>

---

Terraform module for Snowflake Warehouse management

- Creates Snowflake Warehouse
- Can create custom Snowflake Roles with role-to-role, role-to-user assignments
- Can create a set of default, functional roles to simplify access management:
  - `ADMIN` - full access
  - `MONITOR` - abillity to monitor warehouse
  - `USAGE` - abillity to use warehouse

## USAGE

```terraform
module "terraform_snowflake_warehouse" {
  source  = "getindata/warehouse/snowflake"
  context = module.this.context

  name    = "warehouse"
  comment = "My Warehouse"

  warehouse_size = "x-small"

  auto_resume         = true
  auto_suspend        = 600
  initially_suspended = true

  create_default_roles = true

  roles = {
    admin = {
      granted_to_roles = ["SYSADMIN"]
    }
  }
}

```

## NOTES

When upgrading to version `v2.2.x` - all `default_roles` will be recreated using new terraform resources.

## EXAMPLES

- [Simple](examples/simple)
- [Complete](examples/complete)

## Breaking changes in v3.x of the module

Due to replacement of nulllabel (`context.tf`) with context provider, some **breaking changes** were introduced in `v3.0.0` version of this module.

List od code and variable (API) changes:

- Removed `context.tf` file (a single-file module with additonal variables), which implied a removal of all its variables (except `name`):
  - `descriptor_formats`
  - `label_value_case`
  - `label_key_case`
  - `id_length_limit`
  - `regex_replace_chars`
  - `label_order`
  - `additional_tag_map`
  - `tags`
  - `labels_as_tags`
  - `attributes`
  - `delimiter`
  - `stage`
  - `environment`
  - `tenant`
  - `namespace`
  - `enabled`
  - `context`
- Remove support `enabled` flag - that might cause some backward compatibility issues with terraform state (please take into account that proper `move` clauses were added to minimize the impact), but proceed with caution
- Additional `context` provider configuration
- New variables were added, to allow naming configuration via `context` provider:
  - `context_templates`
  - `name_schema`

## Breaking changes in v4.x of the module

- Due to rename of Snowflake terraform provider source, all `versions.tf` files were updated accordingly.

  Please keep in mind to mirror this change in your own repos also.

  For more information about provider rename, refer to [Snowflake documentation](https://github.com/snowflakedb/terraform-provider-snowflake/blob/main/SNOWFLAKEDB_MIGRATION.md).

<!-- BEGIN_TF_DOCS -->




## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_auto_resume"></a> [auto\_resume](#input\_auto\_resume) | Specifies whether to automatically resume a warehouse when a SQL statement (e.g. query) is submitted to it. | `bool` | `true` | no |
| <a name="input_auto_suspend"></a> [auto\_suspend](#input\_auto\_suspend) | Specifies the number of seconds of inactivity after which a warehouse is automatically suspended. | `number` | `null` | no |
| <a name="input_comment"></a> [comment](#input\_comment) | Warehouse comment/description. | `string` | `null` | no |
| <a name="input_context_templates"></a> [context\_templates](#input\_context\_templates) | Map of context templates used for naming conventions - this variable supersedes `naming_scheme.properties` and `naming_scheme.delimiter` configuration | `map(string)` | `{}` | no |
| <a name="input_create_default_roles"></a> [create\_default\_roles](#input\_create\_default\_roles) | Whether the default roles should be created | `bool` | `false` | no |
| <a name="input_enable_query_acceleration"></a> [enable\_query\_acceleration](#input\_enable\_query\_acceleration) | Specifies whether to enable the query acceleration service for queries that rely on this warehouse for compute resources. | `bool` | `true` | no |
| <a name="input_generation"></a> [generation](#input\_generation) | Specifies the generation for the warehouse. Only available for standard warehouses. Valid values are (case-insensitive): 1, 2. | `string` | `null` | no |
| <a name="input_initially_suspended"></a> [initially\_suspended](#input\_initially\_suspended) | Specifies whether the warehouse is created initially in the ‘Suspended’ state. | `bool` | `true` | no |
| <a name="input_max_cluster_count"></a> [max\_cluster\_count](#input\_max\_cluster\_count) | Specifies the maximum number of server clusters for the warehouse. | `number` | `1` | no |
| <a name="input_max_concurrency_level"></a> [max\_concurrency\_level](#input\_max\_concurrency\_level) | Object parameter that specifies the concurrency level for SQL statements (i.e. queries and DML) executed by a warehouse. | `number` | `null` | no |
| <a name="input_min_cluster_count"></a> [min\_cluster\_count](#input\_min\_cluster\_count) | Specifies the minimum number of server clusters for the warehouse (only applies to multi-cluster warehouses). | `number` | `1` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the resource | `string` | n/a | yes |
| <a name="input_name_scheme"></a> [name\_scheme](#input\_name\_scheme) | Naming scheme configuration for the resource. This configuration is used to generate names using context provider:<br/>    - `properties` - list of properties to use when creating the name - is superseded by `var.context_templates`<br/>    - `delimiter` - delimited used to create the name from `properties` - is superseded by `var.context_templates`<br/>    - `context_template_name` - name of the context template used to create the name<br/>    - `replace_chars_regex` - regex to use for replacing characters in property-values created by the provider - any characters that match the regex will be removed from the name<br/>    - `extra_values` - map of extra label-value pairs, used to create a name<br/>    - `uppercase` - convert name to uppercase | <pre>object({<br/>    properties            = optional(list(string), ["environment", "name"])<br/>    delimiter             = optional(string, "_")<br/>    context_template_name = optional(string, "snowflake-warehouse")<br/>    replace_chars_regex   = optional(string, "[^a-zA-Z0-9_]")<br/>    extra_values          = optional(map(string))<br/>    uppercase             = optional(bool, true)<br/>  })</pre> | `{}` | no |
| <a name="input_query_acceleration_max_scale_factor"></a> [query\_acceleration\_max\_scale\_factor](#input\_query\_acceleration\_max\_scale\_factor) | Specifies the maximum scale factor for leasing compute resources for query acceleration. The scale factor is used as a multiplier based on warehouse size. | `number` | `null` | no |
| <a name="input_resource_monitor"></a> [resource\_monitor](#input\_resource\_monitor) | Specifies the name of a resource monitor that is explicitly assigned to the warehouse. | `string` | `null` | no |
| <a name="input_roles"></a> [roles](#input\_roles) | Account roles created on the warehouse level | <pre>map(object({<br/>    name_scheme = optional(object({<br/>      properties            = optional(list(string))<br/>      delimiter             = optional(string)<br/>      context_template_name = optional(string)<br/>      replace_chars_regex   = optional(string)<br/>      extra_labels          = optional(map(string))<br/>      uppercase             = optional(bool)<br/>    }))<br/>    comment              = optional(string)<br/>    role_ownership_grant = optional(string)<br/>    granted_roles        = optional(list(string))<br/>    granted_to_roles     = optional(list(string))<br/>    granted_to_users     = optional(list(string))<br/>    warehouse_grants = optional(object({<br/>      all_privileges    = optional(bool)<br/>      with_grant_option = optional(bool, false)<br/>      privileges        = optional(list(string))<br/>    }))<br/>  }))</pre> | `{}` | no |
| <a name="input_scaling_policy"></a> [scaling\_policy](#input\_scaling\_policy) | Specifies the policy for automatically starting and shutting down clusters in a multi-cluster warehouse running in Auto-scale mode. Valid values are `STANDARD` and `ECONOMY`. | `string` | `null` | no |
| <a name="input_statement_queued_timeout_in_seconds"></a> [statement\_queued\_timeout\_in\_seconds](#input\_statement\_queued\_timeout\_in\_seconds) | Object parameter that specifies the time, in seconds, a SQL statement (query, DDL, DML, etc.) can be queued on a warehouse before it is canceled by the system. | `number` | `null` | no |
| <a name="input_statement_timeout_in_seconds"></a> [statement\_timeout\_in\_seconds](#input\_statement\_timeout\_in\_seconds) | Specifies the time, in seconds, after which a running SQL statement (query, DDL, DML, etc.) is canceled by the system | `number` | `null` | no |
| <a name="input_warehouse_size"></a> [warehouse\_size](#input\_warehouse\_size) | Specifies the size of the virtual warehouse. Possible values are: XSMALL, X-SMALL, SMALL, MEDIUM, LARGE, XLARGE, X-LARGE, XXLARGE, X2LARGE, 2X-LARGE, XXXLARGE, X3LARGE, 3X-LARGE, X4LARGE, 4X-LARGE, X5LARGE, 5X-LARGE, X6LARGE, 6X-LARGE. | `string` | `"X-Small"` | no |
| <a name="input_warehouse_type"></a> [warehouse\_type](#input\_warehouse\_type) | Specifies the type of the virtual warehouse. | `string` | `"STANDARD"` | no |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_roles_deep_merge"></a> [roles\_deep\_merge](#module\_roles\_deep\_merge) | Invicton-Labs/deepmerge/null | 0.1.5 |
| <a name="module_snowflake_custom_role"></a> [snowflake\_custom\_role](#module\_snowflake\_custom\_role) | getindata/role/snowflake | 4.0.0 |
| <a name="module_snowflake_default_role"></a> [snowflake\_default\_role](#module\_snowflake\_default\_role) | getindata/role/snowflake | 4.0.0 |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_roles"></a> [roles](#output\_roles) | Access roles created for warehouse |
| <a name="output_warehouse"></a> [warehouse](#output\_warehouse) | Details of the warehouse |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_context"></a> [context](#provider\_context) | >=0.4.0 |
| <a name="provider_snowflake"></a> [snowflake](#provider\_snowflake) | >= 2.7 |

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_context"></a> [context](#requirement\_context) | >=0.4.0 |
| <a name="requirement_snowflake"></a> [snowflake](#requirement\_snowflake) | >= 2.7 |

## Resources

| Name | Type |
|------|------|
| [snowflake_warehouse.this](https://registry.terraform.io/providers/snowflakedb/snowflake/latest/docs/resources/warehouse) | resource |
| [context_label.this](https://registry.terraform.io/providers/cloudposse/context/latest/docs/data-sources/label) | data source |
<!-- END_TF_DOCS -->

## CONTRIBUTING

Contributions are very welcomed!

Start by reviewing [contribution guide](CONTRIBUTING.md) and our [code of conduct](CODE_OF_CONDUCT.md). After that, start coding and ship your changes by creating a new PR.

## LICENSE

Apache 2 Licensed. See [LICENSE](LICENSE) for full details.

## AUTHORS

<!--- Replace repository name -->
<a href="https://github.com/getindata/REPO_NAME/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=getindata/terraform-snowflake-warehouse" />
</a>

Made with [contrib.rocks](https://contrib.rocks).
