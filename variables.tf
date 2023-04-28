variable "dashboard_name" {
  type        = string
  description = "Dashboard Name for the ecs application monitoring dashboard"
}

variable "production_applicaiton_name" {
  type        = string
  default     = ""
  description = "Production newrelic application name (APM)"
}

variable "production_application_env" {
  type        = string
  default     = "prod"
  description = "Production Application Environment"
}
variable "query_time_range" {
  type        = string
  default     = "3 HOURS"
  description = "Time range for metric query"
}
variable "synthetic_monitor_name" {
  type        = string
  description = "The name of newrelic synthetic monitor created for this application"
}
