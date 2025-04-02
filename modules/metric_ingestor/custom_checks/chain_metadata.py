# For Datadog custom check API see:
# - https://docs.datadoghq.com/developers/custom_checks/write_agent_check/
# - https://github.com/DataDog/datadog-agent/blob/main/docs/dev/checks/README.md

import requests
import json
from decimal import Decimal

from datadog_checks.base import AgentCheck

FETCH_PATH = (
    "/cosmos/staking/v1beta1/validators?status=BOND_STATUS_BONDED&pagination.limit=100"
)
MONIKERS_FILE = "/tmp/monikers.json"


class ChainMetadataCheck(AgentCheck):
    def check(self, instance):
        # Get configuration
        base_api_url = instance.get("base_api_url")
        env = instance.get("env")

        # Fetch validator data
        response = requests.get(f"{base_api_url}{FETCH_PATH}")
        data = response.json()

        self._save_monikers(data)
        self._submit_metrics(data)

    def _submit_metrics(self, data):
        # Calculate total power
        total_power = sum(
            Decimal(v["tokens"]) for v in data["validators"] if not v["jailed"]
        )
        total_power_normalized = total_power / Decimal("1000000000000000000")

        # Submit total voting power
        self.gauge(
            "dydxopsservices.voting_power.total_tokens", float(total_power_normalized)
        )

        # Process validators
        validators = []
        for ext_val in data["validators"]:
            if ext_val["jailed"]:
                continue

            voting_power = Decimal(ext_val["tokens"]) / Decimal("1000000000000000000")
            percentage = (voting_power / total_power_normalized) * Decimal("100")

            validators.append(
                {
                    "validator_address": ext_val["operator_address"],
                    "moniker": self._extract_moniker(ext_val),
                    "voting_power": voting_power,
                    "percentage": percentage,
                }
            )

        # Sort validators by voting power (descending) and limit to active set only
        validators.sort(key=lambda x: x["voting_power"], reverse=True)
        validators = validators[:60]

        # Calculate cumulative share
        cumulative_sum = Decimal("0")
        for ext_val in validators:
            cumulative_sum += ext_val["percentage"]

            tags = [
                f"env:{self.init_config['env']}",
                f"validator_address:{ext_val['validator_address']}",
                f"moniker:{ext_val['moniker']}",
            ]

            # Submit metrics with all values
            self.gauge(
                "dydxopsservices.voting_power.tokens",
                float(ext_val["voting_power"]),
                tags=tags,
            )
            self.gauge(
                "dydxopsservices.voting_power.percentage",
                float(ext_val["percentage"]),
                tags=tags,
            )
            self.gauge(
                "dydxopsservices.voting_power.cumulative_share",
                float(cumulative_sum),
                tags=tags,
            )

    def _save_monikers(self, data):
        monikers = {}

        for ext_val in data["validators"]:
            monikers[ext_val["operator_address"]] = self._extract_moniker(ext_val)

        with open(MONIKERS_FILE, "w") as f:
            json.dump(monikers, f)

    def _extract_moniker(self, validator_entry):
        moniker = validator_entry["description"]["moniker"].strip()
        return moniker
