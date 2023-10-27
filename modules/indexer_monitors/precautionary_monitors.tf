resource "datadog_monitor_json" "average_block_processing_rate" {
  monitor = <<EOF
{
	"id": 117804982,
	"name": "[${var.environment}] Average Indexer block processing is slow",
	"type": "query alert",
	"query": "avg(last_5m):avg:ender.processed_block.timing.avg{env:testnet, service:indexer, success:true} / avg:dydxprotocol.blocktime_block_time_ms{env:testnet} > 0.5",
	"message": "This is not an actionable alert. When this alert fires, that means that the Indexer is processing blocks slow and more time should be invested in improving Ender latency. Please notify Trading if this alert fires.\n\n${local.monitor_suffix_literal}",
	"tags": [
		"team:${var.team}",
		"env:${var.env_tag}"
	],
	"options": {
		"thresholds": {
			"critical": 0.5
		},
		"notify_audit": false,
		"require_full_window": false,
		"notify_no_data": true,
		"renotify_interval": 0,
		"include_tags": false,
		"no_data_timeframe": 60,
		"new_host_delay": 300,
		"silenced": {}
	},
	"priority": null,
	"restricted_roles": null
}
EOF
}

resource "datadog_monitor_json" "p95_block_processing_rate" {
  monitor = <<EOF
{
	"id": 117804982,
	"name": "[${var.environment}] p95 Indexer block processing is slow",
	"type": "query alert",
	"query": "avg(last_5m):avg:ender.processed_block.timing.95percentile{env:testnet, service:indexer, success:true} / avg:dydxprotocol.blocktime_block_time_ms{env:testnet} > 0.75",
	"message": "This is not an actionable alert. When this alert fires, that means that the Indexer is processing blocks slow and more time should be invested in improving Ender latency. Please notify Trading if this alert fires.\n\n${local.monitor_suffix_literal}",
	"tags": [
		"team:${var.team}",
		"env:${var.env_tag}"
	],
	"options": {
		"thresholds": {
			"critical": 0.75
		},
		"notify_audit": false,
		"require_full_window": false,
		"notify_no_data": true,
		"renotify_interval": 0,
		"include_tags": false,
		"no_data_timeframe": 60,
		"new_host_delay": 300,
		"silenced": {}
	},
	"priority": null,
	"restricted_roles": null
}
EOF
}

