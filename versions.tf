terraform {
  required_version = ">= 1.3"
  required_providers {
    snowflake = {
      source  = "snowflakedb/snowflake"
      version = ">= 2.7"
    }
    context = {
      source  = "cloudposse/context"
      version = ">=0.4.0"
    }
  }
}
