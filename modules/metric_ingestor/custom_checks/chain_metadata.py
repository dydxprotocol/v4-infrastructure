# For Datadog custom check API see:
# - https://docs.datadoghq.com/developers/custom_checks/write_agent_check/
# - https://github.com/DataDog/datadog-agent/blob/main/docs/dev/checks/README.md

import requests
import json
from decimal import Decimal
from dataclasses import dataclass, field

# comment for local testing
from datadog_checks.base import AgentCheck


# uncomment for local testing
# class AgentCheck:
#     def gauge(self, name, value, tags=None):
#         print(f"gauge: {name} {value} {tags}")


MONIKERS_FILE = "/tmp/monikers.json"
ACTIVE_SET_SIZE = 50


@dataclass
class Validator:
    validator_address: str
    moniker: str
    jailed: bool
    voting_power: Decimal
    percentage: Decimal = field(default=None)


class ChainMetadataCheck(AgentCheck):
    def check(self, instance):
        base_api_url = instance.get("base_api_url")
        addresses_sharing_metrics = instance.get("addresses_sharing_metrics")

        all_validators = self._get_validators(base_api_url)
        self._save_monikers(all_validators)
        self._submit_is_jailed_metrics(all_validators)
        self._submit_metric_sharing_metrics(all_validators, addresses_sharing_metrics)
        self._submit_voting_power_metrics(all_validators)

    def _get_validators(self, base_api_url):
        validators = []
        pagination_key = None

        while True:
            response = requests.get(
                f"{base_api_url}/cosmos/staking/v1beta1/validators",
                params={
                    "pagination.limit": "100",
                    "pagination.key": pagination_key,
                },
            )

            data = response.json()
            new_validators = [
                Validator(
                    validator_address=v["operator_address"],
                    jailed=v["jailed"],
                    moniker=v["description"]["moniker"].strip(),
                    voting_power=Decimal(v["tokens"]) / Decimal("1000000000000000000"),
                )
                for v in data["validators"]
            ]
            validators.extend(new_validators)

            pagination_key = data["pagination"]["next_key"]
            if not pagination_key:
                break

        return validators

    def _save_monikers(self, validators):
        monikers = {v.validator_address: v.moniker for v in validators}

        with open(MONIKERS_FILE, "w") as f:
            json.dump(monikers, f)

    def _submit_is_jailed_metrics(self, validators):
        for v in validators:
            tags = self._build_tags(v)
            self.gauge("dydxopsservices.is_jailed", int(v.jailed), tags=tags)

    def _submit_metric_sharing_metrics(
        self, all_validators, addresses_sharing_metrics
    ):
        addresses_sharing_metrics_set = set(addresses_sharing_metrics)

        for v in all_validators:
            tags = self._build_tags(v)
            self.gauge(
                "dydxopsservices.is_sharing_metrics",
                int(v.validator_address in addresses_sharing_metrics_set),
                tags=tags,
            )

    def _submit_voting_power_metrics(self, validators):
        # Extract active validators
        active_validators = [v for v in validators if not v.jailed]
        active_validators.sort(key=lambda v: v.voting_power, reverse=True)
        active_validators = active_validators[:ACTIVE_SET_SIZE]

        # Calculate total power
        total_power = sum(Decimal(v.voting_power) for v in active_validators)

        # Calculate percentage of total power for each validator
        for v in active_validators:
            v.percentage = (v.voting_power / total_power) * Decimal("100")

        # Submit total voting power
        self.gauge("dydxopsservices.voting_power.total_tokens", float(total_power))

        # Calculate cumulative share and submit metrics
        cumulative_sum = Decimal("0")

        for v in active_validators:
            cumulative_sum += v.percentage

            tags = self._build_tags(v)

            self.gauge(
                "dydxopsservices.voting_power.tokens",
                float(v.voting_power),
                tags=tags,
            )
            self.gauge(
                "dydxopsservices.voting_power.percentage",
                float(v.percentage),
                tags=tags,
            )
            self.gauge(
                "dydxopsservices.voting_power.cumulative_share",
                float(cumulative_sum),
                tags=tags,
            )

    def _build_tags(self, validator):
        return [
            f"env:{self.init_config['env']}",
            f"validator_address:{validator.validator_address}",
            f"moniker:{validator.moniker}",
        ]


# uncomment for local testing
# if __name__ == "__main__":
#     check = ChainMetadataCheck()
#     check.init_config = {"env": "testnet"}
#     check.check(
#         {
#             "base_api_url": "https://dydx-testnet-api.polkachu.com/",
#             "addresses_sharing_metrics": [
#                 "dydxvaloper1mscvgg4g6yqwsep4elhg8a8z874fyafyc9nn3r",
#             ],
#         }
#     )
