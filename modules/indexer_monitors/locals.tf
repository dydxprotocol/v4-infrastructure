locals {
  monitor_suffix_literal = "{{#is_alert}}\\n${var.pagerduty_tag}\\n{{/is_alert}}\\n\\n{{#is_recovery}}\\n${var.pagerduty_tag}\\n{{/is_recovery}}\\n\\n${var.slack_channel}"
  monitor_suffix         = "{{#is_alert}}\n${var.pagerduty_tag}\n{{/is_alert}}\n\n{{#is_recovery}}\n${var.pagerduty_tag}\n{{/is_recovery}}\n\n${var.slack_channel}"
  wss_url                = "wss://${var.url}/v4/ws"
  https_url              = "https://${var.url}/v4"
  tick_frequency         = 300 # 5 minutes

  api_http_synthetic_monitor_configurations = {
    "height" : {
      url = "${local.https_url}/height"
      targetjsonpath = {
        jsonpath    = "height"
        operator    = "moreThan"
        targetvalue = "0"
      }
      name         = "[${var.environment}] Indexer Comlink /height endpoint"
      message      = "/height endpoint on Comlink is down\n \n Impact:\nFE/API is unable to determine height.\n\nResolution:\nCheck `comlink` logs in AWS / Datadog to see why the endpoint is erroring.\n\n${local.monitor_suffix}"
      monitor_name = "[${var.environment}] Indexer Comlink /height endpoint is down"
    },
    "perpetualMarkets" : {
      url = "${local.https_url}/perpetualMarkets"
      targetjsonpath = {
        jsonpath    = "markets['LINK-USD'].openInterest"
        operator    = "moreThan"
        targetvalue = "0"
      }
      name         = "[${var.environment}] Indexer Comlink /perpetualMarkets endpoint"
      message      = "/perpetualMarkets endpoint on Comlink is down\n \n Impact:\nFE/API wil be degraded from inability to pull perpetual markets.\n\nResolution:\nCheck `comlink` logs in AWS / Datadog to see why the endpoint is erroring.\n\n${local.monitor_suffix}"
      monitor_name = "[${var.environment}] Indexer Comlink /perpetualMarkets endpoint is down"
    }
  }
}
