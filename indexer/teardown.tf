# -----------------------------------------------------------------------------
# Internal-mainnet teardown gate
# -----------------------------------------------------------------------------
# The internal-mainnet indexer is wound down to remove its AWS cost while keeping
# Terraform state + config intact for an emergency rebuild. Internal mainnet is the
# ONLY workspace with environment = "mainnet", so the teardown is derived from the
# environment rather than a workspace variable: it is intrinsic to the mainnet
# workspace and cannot be undone by an errant apply or a forgotten/unset variable.
# dev / staging / testnet (which share this root module in separate workspaces) are
# unaffected — the derived values are identical to the historical behavior there.

# Optional override for the master existence gate. Leave null (default) to derive
# from the environment: mainnet => disabled (full teardown), everything else =>
# enabled. Set to true on the mainnet workspace to rebuild for an emergency restore.
variable "indexer_enabled" {
  type    = bool
  default = null
}

# Optional override for the delete-guard disarm switch. Leave null (default) to
# derive from the environment: mainnet => disarmed (drops RDS deletion_protection
# and enables force_destroy on the full-node snapshot S3 bucket so the destroy can
# complete), everything else => armed. On restore, set both overrides explicitly
# (indexer_enabled = true, indexer_teardown_disarm = false).
variable "indexer_teardown_disarm" {
  type    = bool
  default = null
}

locals {
  # Master existence gate for every resource + module in this workspace. When
  # false, every gated resource/module drops to count 0 and the service/az source
  # locals empty out (collapsing every for_each), tearing down the full stack.
  indexer_enabled = var.indexer_enabled != null ? var.indexer_enabled : var.environment != "mainnet"

  # Disarms delete guards so the teardown destroy can proceed. (The prevent_destroy
  # lifecycle guards on the main ElastiCache group and ACM cert are literals and are
  # dropped in code, not via this switch.)
  indexer_teardown_disarm = var.indexer_teardown_disarm != null ? var.indexer_teardown_disarm : var.environment == "mainnet"
}
