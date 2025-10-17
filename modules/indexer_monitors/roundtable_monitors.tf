resource "datadog_monitor_json" "roundtable_update_affiliate_info_persistent_cache_stale" {
  monitor = <<EOF
{
	"name": "[${var.environment}] Update affiliate info roundtable is not running successfully.",
	"type": "query alert",
    "query": "max(last_5m):avg:rroundtable.persistent_cache_affiliateInfoUpdateTime_lag_seconds{env:${var.environment}} > 600",
	"message": "persistentCache.affiliateInfoUpdateTime is more than 10 minutes in the past. This indicates that update-affiliate-info roundtable has not run successfully in past 10 min -> affiliate_info table is stale.",
	"tags": [
        "team:${var.team}",
        "env:${var.env_tag}"
	],
	"options": {
		"thresholds": {
			"critical": 600
		},
		"notify_audit": false,
		"include_tags": false,
		"notify_no_data": false,
		"new_host_delay": 300,
		"silenced": {}
	},
	"priority": null,
    "restricted_roles": null
}
EOF
}

resource "datadog_monitor_json" "roundtable_update_wallet_total_volume_persistent_cache_stale" {
  monitor = <<EOF
{
	"name": "[${var.environment}] Update wallet total volume roundtable is not running successfully.",
	"type": "query alert",
    "query": "max(last_5m):avg:roundtable.persistent_cache_totalVolumeUpdateTime_lag_seconds{env:${var.environment}} > 600",
    "message": "persistentCache.totalVolumeUpdateTime is more than 10 minutes in the past. This indicates that update-wallet-total-volume roundtable has not run successfully in past 10 min -> totalVolume column of wallets table is stale.",
	"tags": [
        "team:${var.team}",
        "env:${var.env_tag}"
	],
	"options": {
		"thresholds": {
			"critical": 600
		},
		"notify_audit": false,
		"include_tags": false,
		"notify_no_data": false,
		"new_host_delay": 300,
		"silenced": {}
	},
	"priority": null,
    "restricted_roles": null
}
EOF
}