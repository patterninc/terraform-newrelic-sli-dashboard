terraform {
  required_version = ">= 0.13"
  required_providers {
    newrelic = {
      source  = "newrelic/newrelic"
      version = ">= 2.12.0"
    }
  }
}
provider "newrelic" {
  account_id = var.newrelic_account_id
  api_key    = var.newrelic_api_key
  region     = "US"
}

module "demo_sli_dashboard" {
  source                      = "../"
  dashboard_name              = "SLI Dashboard: Demo"
  production_application_env  = "prod"
  production_applicaiton_name = "Demo"
  synthetic_monitor_name      = "example.com"
}
