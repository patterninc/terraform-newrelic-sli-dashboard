locals {
  # creating production setting for adding production envirment matrics
  apm_name         = var.production_applicaiton_name
  env_name         = var.production_application_env
  application_name = trimspace(replace(var.production_applicaiton_name, "/\\(.*\\)/", ""))
}
resource "newrelic_one_dashboard" "dashboard" {
  name        = var.dashboard_name
  permissions = "public_read_only"
  page {
    name = "${local.application_name} - ( ${local.env_name} )"
    widget_markdown {
      title  = "Dashboard Name"
      row    = 1
      column = 1
      height = 3
      width  = 1
      text   = "# **${var.dashboard_name}-${local.env_name}**\n"
    }
    widget_billboard {
      title    = "Application Apdex"
      row      = 2
      column   = 1
      height   = 2
      width    = 3
      warning  = 0.90
      critical = 0.89

      nrql_query {
        query = "SELECT apdex(duration, t: 0.5) FROM Transaction WHERE (appName = '${local.application_name}')  AND name != 'Controller/admin/status' SINCE ${var.query_time_range} ago"
      }
    }
    widget_line {
      title  = "Web Error Rate"
      row    = 1
      column = 4
      height = 3
      width  = 4
      nrql_query {
        query = "SELECT count(apm.service.error.count) / count(apm.service.transaction.duration) as 'Web errors' FROM Metric WHERE (appName = '${local.application_name}') AND (transactionType = 'Web') SINCE ${var.query_time_range} ago TIMESERIES"
      }
    }
    widget_line {
      title  = "Non-Web Error Rate"
      row    = 1
      column = 8
      height = 3
      width  = 4
      nrql_query {
        query = "SELECT count(apm.service.error.count) / count(apm.service.transaction.duration) as 'Non-Web errors' FROM Metric WHERE (appName = '${local.application_name}') AND (transactionType = 'Other') SINCE ${var.query_time_range} ago TIMESERIES"
      }
    }
    widget_billboard {
      title    = "Availability"
      row      = 4
      column   = 1
      height   = 2
      width    = 3
      warning  = 98
      critical = 99

      nrql_query {
        query = "SELECT percentage(count(*), WHERE result = 'SUCCESS') FROM SyntheticCheck WHERE (monitorName = '${var.synthetic_monitor_name}') SINCE ${var.query_time_range} ago"
      }
    }
    widget_line {
      title  = "Latency"
      row    = 4
      column = 4
      height = 4
      width  = 3
      nrql_query {
        query = "SELECT percentage(count(*), where duration <= .30) FROM Transaction WHERE (appName = '${local.application_name}') SINCE ${var.query_time_range} ago TIMESERIES"
      }
    }
  }
}
