# For Datadog custom check API see:
# - https://docs.datadoghq.com/developers/custom_checks/write_agent_check/
# - https://github.com/DataDog/datadog-agent/blob/main/docs/dev/checks/README.md

import urllib.request

from datadog_checks.base import AgentCheck


__version__ = "1.0.0"
METRIC_NAME = "dydxopsservices.validator_endpoint_reachability"


class EndpointChecker(AgentCheck):
    def check(self, instance):
        metric_value = 0

        try:
            response = urllib.request.urlopen(
                instance["openmetrics_endpoint"],
                timeout=int(self.init_config["timeout"]),
            )
            if len(response.read()) > 0:
                metric_value = 1
        except Exception as e:
            print(f"Error ({instance['name']}): {str(e)}")

        self.gauge(
            METRIC_NAME,
            metric_value,
            tags=[
                f"env:{self.init_config['env']}",
                f"name:{instance['name']}",
            ],
        )
