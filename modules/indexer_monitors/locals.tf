locals {
  monitor_suffix = "{{#is_alert}}\\n${var.pagerduty_tag}\\n{{/is_alert}}\\n\\n{{#is_recovery}}\\n${var.pagerduty_tag}\\n{{/is_recovery}}\\n\\n${var.slack_channel}"
  wss_url        = "wss://${var.url}/v4/ws"
  https_url      = "https://${var.url}/v4"
  tick_frequency = 300 # 5 minutes
}
