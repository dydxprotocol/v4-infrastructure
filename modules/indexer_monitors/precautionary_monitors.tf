resource "datadog_monitor_json" "average_block_processing_rate" {
  monitor = <<EOF
{
	"id": 117804982,
	"name": "[${var.environment}] Average Indexer block processing is slow",
	"type": "query alert",
	"query": "avg(last_5m):avg:ender.processed_block.timing.avg{env:${var.environment}, service:indexer, success:true} / avg:dydxprotocol.blocktime_block_time_ms{env:${var.environment}} > 0.5",
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
	"query": "avg(last_5m):avg:ender.processed_block.timing.95percentile{env:${var.environment}, service:indexer, success:true} / avg:dydxprotocol.blocktime_block_time_ms{env:${var.environment}} > 0.75",
	"message": "This is not an actionable alert. When this alert fires, that means that the Indexer is processing blocks slow and more time should be invested in improving Ender latency. Please notify Trading if this alert fires.\n\n${local.monitor_suffix_literal}",
	"tags": [
		"team:${var.team}",
		"env:${var.env_tag}"
	],
	"options": {
		"thresholds": {
			"critical": 0.9
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

resource "datadog_monitor_json" "rds_read_replica_lag" {
  monitor = <<EOF
{
	"id": 139995842,
	"name": "[${var.environment}] RDS read replica lag is high",
	"type": "query alert",
	"query": "avg(last_10m):avg:aws.rds.replica_lag{name:*-indexer-apne1-db-read-replica, environment:${var.environment}} > 2",
	"message": "This is not an actionable alert. When this alert fires, that means that the RDS read replica lag is high.\n\n${local.monitor_suffix_literal}",
	"tags": [
		"team:${var.team}",
		"env:${var.env_tag}"
	],
	"options": {
		"thresholds": {
			"critical": 1
		},
		"notify_audit": false,
		"require_full_window": false,
		"notify_no_data": true,
		"renotify_interval": 0,
		"include_tags": false,
		"no_data_timeframe": 60,
		"evaluation_delay": 900,
		"new_host_delay": 300,
		"silenced": {}
	},
	"priority": null,
	"restricted_roles": null
}
EOF
}

resource "datadog_monitor_json" "websocket_stream_destroyed" {
  monitor = <<EOF
{
    "id": 2836481,
    "name": "[${var.environment}] Underlying socket was destroyed, leading to lost websocket messages.",
    "type": "query alert",
    "query": "sum(last_5m):avg:socks.ws_send.stream_destroyed_errors{env:${var.environment}}.as_count() > 500",
    "message": "Underlying socket was destroyed, leading to lost messages. Check if there are any CPU/memory spikes on any specific tasks. This should auto-recover.\n\n${local.monitor_suffix_literal}",
    "tags": [
        "team:${var.team}",
        "env:${var.env_tag}"
    ],
    "options": {
        "thresholds": {
            "critical": 500
        },
        "notify_audit": false,
        "include_tags": false,
        "notify_no_data": false,
        "silenced": {}
    },
    "priority": null,
    "restricted_roles": null
}
EOF
}

resource "datadog_monitor_json" "stale_compliance_data" {
  count   = var.environment == "mainnet" ? 1 : 0
  monitor = <<EOF
{
	"id": 152007506,
	"name": "[${var.environment}] Compliance data stale.",
	"type": "query alert",
	"query": "max(last_10m):max:roundtable.update_compliance_data.num_active_addresses_with_stale_compliance{env:${var.environment}} + max:roundtable.update_compliance_data.num_inactive_addresses_with_stale_compliance{env:${var.environment}} > 1000",
	"message": "Addresses have stale compliance data. Check the two metrics to determine if active or inactive addresses are stale. update-compliance-data.ts roundtable is responsible for updating compliance data.",
	"tags": [
        "team:${var.team}",
        "env:${var.env_tag}"
	],
	"options": {
		"thresholds": {
			"critical": 1000
		},
		"notify_audit": false,
		"include_tags": false,
		"notify_no_data": false,
		"silenced": {}
	},
	"priority": null,
    "restricted_roles": null
}
EOF
}
