variable "name" {
  description = "Name of the resource"
  type        = string
}

variable "comment" {
  description = "Warehouse comment/description."
  type        = string
  default     = null
}

variable "warehouse_size" {
  description = "Specifies the size of the virtual warehouse. Possible values are: XSMALL, X-SMALL, SMALL, MEDIUM, LARGE, XLARGE, X-LARGE, XXLARGE, X2LARGE, 2X-LARGE, XXXLARGE, X3LARGE, 3X-LARGE, X4LARGE, 4X-LARGE, X5LARGE, 5X-LARGE, X6LARGE, 6X-LARGE."
  type        = string
  default     = "X-Small"
}

variable "warehouse_type" {
  description = "Specifies the type of the virtual warehouse."
  type        = string
  default     = "STANDARD"
  validation {
    condition     = contains(["STANDARD", "SNOWPARK-OPTIMIZED"], var.warehouse_type)
    error_message = "Invalid warehouse type. Possible values are: \"STANDARD\", \"SNOWPARK-OPTIMIZED\""
  }
}

variable "generation" {
  description = "Specifies the generation for the warehouse. Only available for standard warehouses. Valid values are: 1, 2, docs: <https://docs.snowflake.com/en/user-guide/warehouses-gen2>."
  type        = string
  default     = null
  validation {
    condition     = var.generation == null ? true : contains(["1", "2"], var.generation)
    error_message = "Invalid generation. Possible values are: \"1\", \"2\""
  }
}

variable "auto_resume" {
  description = "Specifies whether to automatically resume a warehouse when a SQL statement (e.g. query) is submitted to it."
  type        = bool
  default     = true
}

variable "auto_suspend" {
  description = "Specifies the number of seconds of inactivity after which a warehouse is automatically suspended."
  type        = number
  default     = null
}

variable "initially_suspended" {
  description = "Specifies whether the warehouse is created initially in the ‘Suspended’ state."
  type        = bool
  default     = true
}

variable "min_cluster_count" {
  description = "Specifies the minimum number of server clusters for the warehouse (only applies to multi-cluster warehouses)."
  type        = number
  default     = 1
}

variable "max_cluster_count" {
  description = "Specifies the maximum number of server clusters for the warehouse."
  type        = number
  default     = 1
}

variable "scaling_policy" {
  description = "Specifies the policy for automatically starting and shutting down clusters in a multi-cluster warehouse running in Auto-scale mode. Valid values are `STANDARD` and `ECONOMY`."
  type        = string
  default     = null
}

variable "max_concurrency_level" {
  description = "Object parameter that specifies the concurrency level for SQL statements (i.e. queries and DML) executed by a warehouse."
  type        = number
  default     = null
}

variable "enable_query_acceleration" {
  description = "Specifies whether to enable the query acceleration service for queries that rely on this warehouse for compute resources."
  type        = bool
  default     = true
}

variable "query_acceleration_max_scale_factor" {
  description = "Specifies the maximum scale factor for leasing compute resources for query acceleration. The scale factor is used as a multiplier based on warehouse size."
  type        = number
  default     = null
}

variable "statement_timeout_in_seconds" {
  description = "Specifies the time, in seconds, after which a running SQL statement (query, DDL, DML, etc.) is canceled by the system"
  type        = number
  default     = null
}

variable "statement_queued_timeout_in_seconds" {
  description = "Object parameter that specifies the time, in seconds, a SQL statement (query, DDL, DML, etc.) can be queued on a warehouse before it is canceled by the system."
  type        = number
  default     = null
}

variable "resource_monitor" {
  description = "Specifies the name of a resource monitor that is explicitly assigned to the warehouse."
  type        = string
  default     = null
}

variable "roles" {
  description = "Account roles created on the warehouse level"
  type = map(object({
    name_scheme = optional(object({
      properties            = optional(list(string))
      delimiter             = optional(string)
      context_template_name = optional(string)
      replace_chars_regex   = optional(string)
      extra_labels          = optional(map(string))
      uppercase             = optional(bool)
    }))
    comment              = optional(string)
    role_ownership_grant = optional(string)
    granted_roles        = optional(list(string))
    granted_to_roles     = optional(list(string))
    granted_to_users     = optional(list(string))
    warehouse_grants = optional(object({
      all_privileges    = optional(bool)
      with_grant_option = optional(bool, false)
      privileges        = optional(list(string))
    }))
  }))
  default = {}
}

variable "create_default_roles" {
  description = "Whether the default roles should be created"
  type        = bool
  default     = false
}

variable "name_scheme" {
  description = <<EOT
  Naming scheme configuration for the resource. This configuration is used to generate names using context provider:
    - `properties` - list of properties to use when creating the name - is superseded by `var.context_templates`
    - `delimiter` - delimited used to create the name from `properties` - is superseded by `var.context_templates`
    - `context_template_name` - name of the context template used to create the name
    - `replace_chars_regex` - regex to use for replacing characters in property-values created by the provider - any characters that match the regex will be removed from the name
    - `extra_values` - map of extra label-value pairs, used to create a name
    - `uppercase` - convert name to uppercase
  EOT
  type = object({
    properties            = optional(list(string), ["environment", "name"])
    delimiter             = optional(string, "_")
    context_template_name = optional(string, "snowflake-warehouse")
    replace_chars_regex   = optional(string, "[^a-zA-Z0-9_]")
    extra_values          = optional(map(string))
    uppercase             = optional(bool, true)
  })
  default = {}
}

variable "context_templates" {
  description = "Map of context templates used for naming conventions - this variable supersedes `naming_scheme.properties` and `naming_scheme.delimiter` configuration"
  type        = map(string)
  default     = {}
}
