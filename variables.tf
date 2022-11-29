variable "comment" {
  description = "Warehouse comment/description."
  type        = string
  default     = null
}

variable "warehouse_size" {
  description = "Specifies the size of the virtual warehouse."
  type        = string
  default     = "X-Small"
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
  description = "Specifies the policy for automatically starting and shutting down clusters in a multi-cluster warehouse running in Auto-scale mode."
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
  description = "Roles created on the warehouse level"
  type        = any
  default     = {}
}
