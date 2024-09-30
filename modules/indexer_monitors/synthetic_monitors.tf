resource "datadog_synthetics_test" "socks" {
  type    = "api"
  subtype = "websocket"
  status  = "live"

  request_definition {
    url = local.wss_url
  }

  request_headers = {
    Content-Type = "application/json"
  }

  assertion {
    type     = "responseTime"
    operator = "lessThan"
    target   = "3000"
  }

  assertion {
    type     = "receivedMessage"
    operator = "contains"
    target   = "connected"
  }

  name    = "[${var.environment}] Indexer Websocket connection test"
  message = "Websocket connections cannot be established with the Indexer.\n\n Impact:\nFE/API wil be degraded from being unable to connect to websockets.\n\nResolution:\nCheck `socks` logs in AWS / Datadog to see why the endpoint is erroring.\n\n${local.monitor_suffix}"
  tags    = ["team:${var.team}", "env:${var.env_tag}"]
  locations = [
    "aws:ap-east-1",
    "aws:ap-northeast-1",
    "aws:eu-central-1",
    "aws:eu-west-1",
  ]

  options_list {
    monitor_name = "[${var.environment}] Indexer Socks is down"
    monitor_options {
      renotify_interval = 0
    }
    retry {
      count    = 3
      interval = local.retry_interval
    }
    tick_every = local.tick_frequency
  }
}

resource "datadog_synthetics_test" "api_http_synthetic_monitors" {
  for_each = local.api_http_synthetic_monitor_configurations

  type    = "api"
  subtype = "http"
  status  = "live"

  request_definition {
    method = "GET"
    url    = each.value.url
  }

  request_headers = {
    Content-Type = "application/json"
  }

  assertion {
    operator = "lessThan"
    type     = "responseTime"
    target   = "3000"
  }

  assertion {
    operator = "is"
    type     = "statusCode"
    target   = "200"
  }

  assertion {
    operator = "validatesJSONPath"
    type     = "body"
    targetjsonpath {
      jsonpath    = each.value.targetjsonpath.jsonpath
      operator    = each.value.targetjsonpath.operator
      targetvalue = each.value.targetjsonpath.targetvalue
    }
  }

  name    = each.value.name
  message = each.value.message
  tags    = ["team:${var.team}", "env:${var.env_tag}"]
  locations = [
    "aws:ap-east-1",
    "aws:ap-northeast-1",
    "aws:eu-central-1",
    "aws:eu-west-1",
  ]

  options_list {
    monitor_name = each.value.monitor_name
    monitor_options {
      renotify_interval = 0
    }
    retry {
      count    = local.retry_count
      interval = local.retry_interval
    }
    tick_every = local.tick_frequency
  }
}

resource "datadog_synthetics_test" "comlink_trades" {
  type    = "api"
  subtype = "multi"
  status  = "live"

  api_step {
    name    = "BTC trades"
    subtype = "http"

    request_definition {
      method = "GET"
      url    = "${local.https_url}/trades/perpetualMarket/BTC-USD"
    }

    request_headers = {
      Content-Type = "application/json"
    }

    retry {
      count    = local.retry_count
      interval = local.tick_frequency
    }

    assertion {
      operator = "lessThan"
      type     = "responseTime"
      target   = "5000"
    }

    assertion {
      operator = "is"
      type     = "statusCode"
      target   = "200"
    }

    assertion {
      operator = "is"
      property = "content-type"
      type     = "header"
      target   = "application/json; charset=utf-8"
    }

    assertion {
      type     = "body"
      operator = "validatesJSONPath"
      targetjsonpath {
        jsonpath    = "trades.length"
        operator    = "moreThan"
        targetvalue = "-1"
      }
    }
  }

  api_step {
    name    = "ETH trades"
    subtype = "http"

    request_definition {
      method = "GET"
      url    = "${local.https_url}/trades/perpetualMarket/ETH-USD"
    }

    request_headers = {
      Content-Type = "application/json"
    }

    retry {
      count    = local.retry_count
      interval = local.tick_frequency
    }

    assertion {
      operator = "lessThan"
      type     = "responseTime"
      target   = "5000"
    }

    assertion {
      operator = "is"
      type     = "statusCode"
      target   = "200"
    }

    assertion {
      operator = "is"
      property = "content-type"
      type     = "header"
      target   = "application/json; charset=utf-8"
    }

    assertion {
      type     = "body"
      operator = "validatesJSONPath"
      targetjsonpath {
        jsonpath    = "trades.length"
        operator    = "moreThan"
        targetvalue = "-1"
      }
    }
  }

  name    = "[${var.environment}] Indexer Comlink /trades endpoint"
  message = "/trades endpoint on Comlink is down\n \n Impact:\nFE/API wil be degraded from lack of trades.\n\nResolution:\nCheck `comlink` logs in AWS / Datadog to see why the endpoint is erroring.\n\n${local.monitor_suffix}"
  tags    = ["team:${var.team}", "env:${var.env_tag}"]
  locations = [
    "aws:ap-east-1",
    "aws:ap-northeast-1",
    "aws:eu-central-1",
    "aws:eu-west-1",
  ]

  options_list {
    monitor_name = "[${var.environment}] Indexer Comlink /trades endpoint is down"
    monitor_options {
      renotify_interval = 0
    }
    tick_every = local.tick_frequency
  }
}

resource "datadog_synthetics_test" "comlink_orderbook" {
  type    = "api"
  subtype = "multi"
  status  = "live"

  api_step {
    name    = "BTC orderbook"
    subtype = "http"

    request_definition {
      method = "GET"
      url    = "${local.https_url}/orderbooks/perpetualMarket/BTC-USD"
    }

    request_headers = {
      Content-Type = "application/json"
    }

    retry {
      count    = local.retry_count
      interval = local.retry_interval
    }

    assertion {
      operator = "lessThan"
      type     = "responseTime"
      target   = "3000"
    }

    assertion {
      operator = "is"
      type     = "statusCode"
      target   = "200"
    }

    assertion {
      operator = "is"
      property = "content-type"
      type     = "header"
      target   = "application/json; charset=utf-8"
    }

    assertion {
      type     = "body"
      operator = "validatesJSONPath"
      targetjsonpath {
        jsonpath    = "asks.length"
        operator    = "moreThan"
        targetvalue = "-1"
      }
    }

    assertion {
      type     = "body"
      operator = "validatesJSONPath"
      targetjsonpath {
        jsonpath    = "bids.length"
        operator    = "moreThan"
        targetvalue = "-1"
      }
    }
  }

  api_step {
    name    = "ETH orderbook"
    subtype = "http"

    request_definition {
      method = "GET"
      url    = "${local.https_url}/orderbooks/perpetualMarket/ETH-USD"
    }

    request_headers = {
      Content-Type = "application/json"
    }

    retry {
      count    = local.retry_count
      interval = local.retry_interval
    }

    assertion {
      operator = "lessThan"
      type     = "responseTime"
      target   = "3000"
    }

    assertion {
      operator = "is"
      type     = "statusCode"
      target   = "200"
    }

    assertion {
      operator = "is"
      property = "content-type"
      type     = "header"
      target   = "application/json; charset=utf-8"
    }

    assertion {
      type     = "body"
      operator = "validatesJSONPath"
      targetjsonpath {
        jsonpath    = "asks.length"
        operator    = "moreThan"
        targetvalue = "-1"
      }
    }

    assertion {
      type     = "body"
      operator = "validatesJSONPath"
      targetjsonpath {
        jsonpath    = "bids.length"
        operator    = "moreThan"
        targetvalue = "-1"
      }
    }
  }

  name    = "[${var.environment}] Indexer Comlink /orderbook endpoint"
  message = "/orderbooks endpoint is down.\n\nImpact:\nFE / API experience degraded as no orderbooks can be fetched.\n\nResolution:\nCheck `comlink` logs in AWS / Datadog to determine why the endpoint is erroring.\n\n${local.monitor_suffix}"
  tags    = ["team:${var.team}", "env:${var.env_tag}"]
  locations = [
    "aws:ap-east-1",
    "aws:ap-northeast-1",
    "aws:eu-central-1",
    "aws:eu-west-1",
  ]

  options_list {
    monitor_name = "[${var.environment}] Indexer Comlink /orderbook endpoint is down"
    monitor_options {
      renotify_interval = 0
    }
    tick_every = local.tick_frequency
  }
}
