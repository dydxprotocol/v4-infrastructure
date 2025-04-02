# For docs on custom OpenMetrics check see:
# - https://docs.datadoghq.com/developers/custom_checks/prometheus/

import os
import json

from datadog_checks.base import OpenMetricsBaseCheckV2
from prometheus_client.parser import text_string_to_metric_families

__version__ = "1.0.0"
REACHABILITY_METRIC_NAME = "dydxopsservices.validator_endpoint_reachability"
MONIKERS_FILE = "/tmp/monikers.json"

class ValidatorMetricsCheck(OpenMetricsBaseCheckV2):
    def __init__(self, name, init_config, instances):
        super(ValidatorMetricsCheck, self).__init__(name, init_config, instances)

    def check(self, instance):
        monikers = self._get_monikers()
        if not monikers:
            self.log.warning("No monikers found")
            return

        dynamic_tags = self._get_dynamic_tags(instance, monikers)
        all_tags = instance["tags"] + dynamic_tags
        self.set_dynamic_tags(*dynamic_tags)

        try:
            super().check(instance)
        except Exception as e:
            self.log.error("Error checking instance: %s", e)
            is_reachable = 0
        else:
            is_reachable = 1

        self.gauge(
            REACHABILITY_METRIC_NAME,
            is_reachable,
            tags=all_tags,
        )

    def _get_dynamic_tags(self, instance, monikers):
        address = instance["address"]
        machine_id = instance["machine_id"]

        real_moniker = monikers.get(address)
        if real_moniker:
            output_moniker = f"{real_moniker}_{machine_id}" if machine_id else real_moniker
            return [
                f"moniker:{output_moniker}",
                f"validator_name:{output_moniker}",
            ]
        else:
            self.log.warning(f"No moniker found for address: {address}")
            return []

    def _get_monikers(self):
        if not os.path.exists(MONIKERS_FILE):
            return {}

        with open(MONIKERS_FILE, "r") as f:
            return json.load(f)
