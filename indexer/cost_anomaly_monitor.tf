provider "awscc" {
  alias  = "us-east-2"
  region = "us-east-2"
}

provider "awscc" {
  alias  = "ap-northeast-1"
  region = "ap-northeast-1"
}

resource "awscc_ce_anomaly_monitor" "service_spike_monitor_us_east_2" {
  provider          = awscc.us-east-2
  monitor_name      = "aws-service-spike-monitor-us-east-2"
  monitor_type      = "DIMENSIONAL"
  monitor_dimension = "SERVICE"
}

resource "awscc_ce_anomaly_monitor" "service_spike_monitor_ap_northeast_1" {
  provider          = awscc.ap-northeast-1
  monitor_name      = "aws-service-spike-monitor-ap-northeast-1"
  monitor_type      = "DIMENSIONAL"
  monitor_dimension = "SERVICE"
}

resource "awscc_ce_anomaly_subscription" "email_alert_us_east_2" {
  provider          = awscc.us-east-2
  subscription_name = "eng-team-us-east-2"
  monitor_arn_list  = [awscc_ce_anomaly_monitor.service_spike_monitor_us_east_2.id]
  frequency         = "IMMEDIATE"
  subscribers = [
    {
      address           = "backend-engineering@dydx.exchange"
      type              = "EMAIL"
      subscription_type = "ACTUAL"
    },
    {
      address           = "finance@dydx.exchange"
      type              = "EMAIL"
      subscription_type = "ACTUAL"
    }
  ]
}

resource "awscc_ce_anomaly_subscription" "email_alert_ap_northeast_1" {
  provider          = awscc.ap-northeast-1
  subscription_name = "eng-team-ap-northeast-1"
  monitor_arn_list  = [awscc_ce_anomaly_monitor.service_spike_monitor_ap_northeast_1.id]
  frequency         = "IMMEDIATE"
  subscribers = [
    {
      address           = "backend-engineering@dydx.exchange"
      type              = "EMAIL"
      subscription_type = "ACTUAL"
    },
    {
      address           = "finance@dydx.exchange"
      type              = "EMAIL"
      subscription_type = "ACTUAL"
    }
  ]
}