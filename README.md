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

* Creates Snowflake Warehouse
* Can create custom Snowflake Roles with role-to-role, role-to-user assignments
* Can create a set of default, functional roles to simplify access management:
  * `ADMIN` - full access
  * `MONITOR` - abillity to monitor warehouse
  * `USAGE` - abillity to use warehouse

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

* [Simple](examples/simple)
* [Complete](examples/complete)

<!-- BEGIN_TF_DOCS -->




## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_tag_map"></a> [additional\_tag\_map](#input\_additional\_tag\_map) | Additional key-value pairs to add to each map in `tags_as_list_of_maps`. Not added to `tags` or `id`.<br>This is for some rare cases where resources want additional configuration of tags<br>and therefore take a list of maps with tag key, value, and additional configuration. | `map(string)` | `{}` | no |
| <a name="input_attributes"></a> [attributes](#input\_attributes) | ID element. Additional attributes (e.g. `workers` or `cluster`) to add to `id`,<br>in the order they appear in the list. New attributes are appended to the<br>end of the list. The elements of the list are joined by the `delimiter`<br>and treated as a single ID element. | `list(string)` | `[]` | no |
| <a name="input_auto_resume"></a> [auto\_resume](#input\_auto\_resume) | Specifies whether to automatically resume a warehouse when a SQL statement (e.g. query) is submitted to it. | `bool` | `true` | no |
| <a name="input_auto_suspend"></a> [auto\_suspend](#input\_auto\_suspend) | Specifies the number of seconds of inactivity after which a warehouse is automatically suspended. | `number` | `null` | no |
| <a name="input_comment"></a> [comment](#input\_comment) | Warehouse comment/description. | `string` | `null` | no |
| <a name="input_context"></a> [context](#input\_context) | Single object for setting entire context at once.<br>See description of individual variables for details.<br>Leave string and numeric variables as `null` to use default value.<br>Individual variable settings (non-null) override settings in context object,<br>except for attributes, tags, and additional\_tag\_map, which are merged. | `any` | <pre>{<br>  "additional_tag_map": {},<br>  "attributes": [],<br>  "delimiter": null,<br>  "descriptor_formats": {},<br>  "enabled": true,<br>  "environment": null,<br>  "id_length_limit": null,<br>  "label_key_case": null,<br>  "label_order": [],<br>  "label_value_case": null,<br>  "labels_as_tags": [<br>    "unset"<br>  ],<br>  "name": null,<br>  "namespace": null,<br>  "regex_replace_chars": null,<br>  "stage": null,<br>  "tags": {},<br>  "tenant": null<br>}</pre> | no |
| <a name="input_create_default_roles"></a> [create\_default\_roles](#input\_create\_default\_roles) | Whether the default roles should be created | `bool` | `false` | no |
| <a name="input_delimiter"></a> [delimiter](#input\_delimiter) | Delimiter to be used between ID elements.<br>Defaults to `-` (hyphen). Set to `""` to use no delimiter at all. | `string` | `null` | no |
| <a name="input_descriptor_formats"></a> [descriptor\_formats](#input\_descriptor\_formats) | Describe additional descriptors to be output in the `descriptors` output map.<br>Map of maps. Keys are names of descriptors. Values are maps of the form<br>`{<br>   format = string<br>   labels = list(string)<br>}`<br>(Type is `any` so the map values can later be enhanced to provide additional options.)<br>`format` is a Terraform format string to be passed to the `format()` function.<br>`labels` is a list of labels, in order, to pass to `format()` function.<br>Label values will be normalized before being passed to `format()` so they will be<br>identical to how they appear in `id`.<br>Default is `{}` (`descriptors` output will be empty). | `any` | `{}` | no |
| <a name="input_descriptor_name"></a> [descriptor\_name](#input\_descriptor\_name) | Name of the descriptor used to form a resource name | `string` | `"snowflake-warehouse"` | no |
| <a name="input_enable_query_acceleration"></a> [enable\_query\_acceleration](#input\_enable\_query\_acceleration) | Specifies whether to enable the query acceleration service for queries that rely on this warehouse for compute resources. | `bool` | `true` | no |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | Set to false to prevent the module from creating any resources | `bool` | `null` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | ID element. Usually used for region e.g. 'uw2', 'us-west-2', OR role 'prod', 'staging', 'dev', 'UAT' | `string` | `null` | no |
| <a name="input_id_length_limit"></a> [id\_length\_limit](#input\_id\_length\_limit) | Limit `id` to this many characters (minimum 6).<br>Set to `0` for unlimited length.<br>Set to `null` for keep the existing setting, which defaults to `0`.<br>Does not affect `id_full`. | `number` | `null` | no |
| <a name="input_initially_suspended"></a> [initially\_suspended](#input\_initially\_suspended) | Specifies whether the warehouse is created initially in the ‘Suspended’ state. | `bool` | `true` | no |
| <a name="input_label_key_case"></a> [label\_key\_case](#input\_label\_key\_case) | Controls the letter case of the `tags` keys (label names) for tags generated by this module.<br>Does not affect keys of tags passed in via the `tags` input.<br>Possible values: `lower`, `title`, `upper`.<br>Default value: `title`. | `string` | `null` | no |
| <a name="input_label_order"></a> [label\_order](#input\_label\_order) | The order in which the labels (ID elements) appear in the `id`.<br>Defaults to ["namespace", "environment", "stage", "name", "attributes"].<br>You can omit any of the 6 labels ("tenant" is the 6th), but at least one must be present. | `list(string)` | `null` | no |
| <a name="input_label_value_case"></a> [label\_value\_case](#input\_label\_value\_case) | Controls the letter case of ID elements (labels) as included in `id`,<br>set as tag values, and output by this module individually.<br>Does not affect values of tags passed in via the `tags` input.<br>Possible values: `lower`, `title`, `upper` and `none` (no transformation).<br>Set this to `title` and set `delimiter` to `""` to yield Pascal Case IDs.<br>Default value: `lower`. | `string` | `null` | no |
| <a name="input_labels_as_tags"></a> [labels\_as\_tags](#input\_labels\_as\_tags) | Set of labels (ID elements) to include as tags in the `tags` output.<br>Default is to include all labels.<br>Tags with empty values will not be included in the `tags` output.<br>Set to `[]` to suppress all generated tags.<br>**Notes:**<br>  The value of the `name` tag, if included, will be the `id`, not the `name`.<br>  Unlike other `null-label` inputs, the initial setting of `labels_as_tags` cannot be<br>  changed in later chained modules. Attempts to change it will be silently ignored. | `set(string)` | <pre>[<br>  "default"<br>]</pre> | no |
| <a name="input_max_cluster_count"></a> [max\_cluster\_count](#input\_max\_cluster\_count) | Specifies the maximum number of server clusters for the warehouse. | `number` | `1` | no |
| <a name="input_max_concurrency_level"></a> [max\_concurrency\_level](#input\_max\_concurrency\_level) | Object parameter that specifies the concurrency level for SQL statements (i.e. queries and DML) executed by a warehouse. | `number` | `null` | no |
| <a name="input_min_cluster_count"></a> [min\_cluster\_count](#input\_min\_cluster\_count) | Specifies the minimum number of server clusters for the warehouse (only applies to multi-cluster warehouses). | `number` | `1` | no |
| <a name="input_name"></a> [name](#input\_name) | ID element. Usually the component or solution name, e.g. 'app' or 'jenkins'.<br>This is the only ID element not also included as a `tag`.<br>The "name" tag is set to the full `id` string. There is no tag with the value of the `name` input. | `string` | `null` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | ID element. Usually an abbreviation of your organization name, e.g. 'eg' or 'cp', to help ensure generated IDs are globally unique | `string` | `null` | no |
| <a name="input_query_acceleration_max_scale_factor"></a> [query\_acceleration\_max\_scale\_factor](#input\_query\_acceleration\_max\_scale\_factor) | Specifies the maximum scale factor for leasing compute resources for query acceleration. The scale factor is used as a multiplier based on warehouse size. | `number` | `null` | no |
| <a name="input_regex_replace_chars"></a> [regex\_replace\_chars](#input\_regex\_replace\_chars) | Terraform regular expression (regex) string.<br>Characters matching the regex will be removed from the ID elements.<br>If not set, `"/[^a-zA-Z0-9-]/"` is used to remove all characters other than hyphens, letters and digits. | `string` | `null` | no |
| <a name="input_resource_monitor"></a> [resource\_monitor](#input\_resource\_monitor) | Specifies the name of a resource monitor that is explicitly assigned to the warehouse. | `string` | `null` | no |
| <a name="input_roles"></a> [roles](#input\_roles) | Account roles created on the warehouse level | <pre>map(object({<br>    enabled              = optional(bool, true)<br>    descriptor_name      = optional(string, "snowflake-role")<br>    comment              = optional(string)<br>    role_ownership_grant = optional(string)<br>    granted_roles        = optional(list(string))<br>    granted_to_roles     = optional(list(string))<br>    granted_to_users     = optional(list(string))<br>    warehouse_grants = optional(object({<br>      all_privileges    = optional(bool)<br>      with_grant_option = optional(bool, false)<br>      privileges        = optional(list(string))<br>    }))<br>  }))</pre> | `{}` | no |
| <a name="input_scaling_policy"></a> [scaling\_policy](#input\_scaling\_policy) | Specifies the policy for automatically starting and shutting down clusters in a multi-cluster warehouse running in Auto-scale mode. Valid values are `STANDARD` and `ECONOMY`. | `string` | `null` | no |
| <a name="input_stage"></a> [stage](#input\_stage) | ID element. Usually used to indicate role, e.g. 'prod', 'staging', 'source', 'build', 'test', 'deploy', 'release' | `string` | `null` | no |
| <a name="input_statement_queued_timeout_in_seconds"></a> [statement\_queued\_timeout\_in\_seconds](#input\_statement\_queued\_timeout\_in\_seconds) | Object parameter that specifies the time, in seconds, a SQL statement (query, DDL, DML, etc.) can be queued on a warehouse before it is canceled by the system. | `number` | `null` | no |
| <a name="input_statement_timeout_in_seconds"></a> [statement\_timeout\_in\_seconds](#input\_statement\_timeout\_in\_seconds) | Specifies the time, in seconds, after which a running SQL statement (query, DDL, DML, etc.) is canceled by the system | `number` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional tags (e.g. `{'BusinessUnit': 'XYZ'}`).<br>Neither the tag keys nor the tag values will be modified by this module. | `map(string)` | `{}` | no |
| <a name="input_tenant"></a> [tenant](#input\_tenant) | ID element \_(Rarely used, not included by default)\_. A customer identifier, indicating who this instance of a resource is for | `string` | `null` | no |
| <a name="input_warehouse_size"></a> [warehouse\_size](#input\_warehouse\_size) | Specifies the size of the virtual warehouse. Possible values are: XSMALL, X-SMALL, SMALL, MEDIUM, LARGE, XLARGE, X-LARGE, XXLARGE, X2LARGE, 2X-LARGE, XXXLARGE, X3LARGE, 3X-LARGE, X4LARGE, 4X-LARGE, X5LARGE, 5X-LARGE, X6LARGE, 6X-LARGE. | `string` | `"X-Small"` | no |
| <a name="input_warehouse_type"></a> [warehouse\_type](#input\_warehouse\_type) | Specifies the type of the virtual warehouse. | `string` | `"STANDARD"` | no |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_roles_deep_merge"></a> [roles\_deep\_merge](#module\_roles\_deep\_merge) | Invicton-Labs/deepmerge/null | 0.1.5 |
| <a name="module_snowflake_custom_role"></a> [snowflake\_custom\_role](#module\_snowflake\_custom\_role) | getindata/role/snowflake | 2.1.0 |
| <a name="module_snowflake_default_role"></a> [snowflake\_default\_role](#module\_snowflake\_default\_role) | getindata/role/snowflake | 2.1.0 |
| <a name="module_this"></a> [this](#module\_this) | cloudposse/label/null | 0.25.0 |
| <a name="module_warehouse_label"></a> [warehouse\_label](#module\_warehouse\_label) | cloudposse/label/null | 0.25.0 |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_roles"></a> [roles](#output\_roles) | Access roles created for warehouse |
| <a name="output_warehouse"></a> [warehouse](#output\_warehouse) | Details of the warehouse |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_snowflake"></a> [snowflake](#provider\_snowflake) | ~> 0.94 |

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_snowflake"></a> [snowflake](#requirement\_snowflake) | ~> 0.94 |

## Resources

| Name | Type |
|------|------|
| [snowflake_warehouse.this](https://registry.terraform.io/providers/Snowflake-Labs/snowflake/latest/docs/resources/warehouse) | resource |
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
