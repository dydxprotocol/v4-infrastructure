# -----------------------------------------------------------------------------
# Internal-mainnet teardown gate
# -----------------------------------------------------------------------------
# These two workspace-scoped switches drive the wind-down of the internal-mainnet
# indexer while keeping Terraform state + config intact for an emergency rebuild.
# Both default to today's behavior, so dev / staging / testnet (which share this
# root module in separate workspaces) are unaffected. Only the internal-mainnet
# `indexers` workspace ever sets them. See teardown_moved.tf for the address
# migrations that make the default (enabled) path a no-op for existing state.

# Master existence switch for every resource + module in this workspace. When
# false, every gated resource/module drops to count 0 (and the service/az source
# locals empty out, collapsing every for_each), destroying the full stack.
variable "indexer_enabled" {
  type    = bool
  default = true
}

# Disarms delete guards so the teardown destroy can proceed. Set to true one apply
# BEFORE indexer_enabled is flipped to false: drops RDS deletion_protection and
# enables force_destroy on the full-node snapshot S3 bucket. (The prevent_destroy
# lifecycle guards on the main ElastiCache group and ACM cert are literals and are
# dropped in code, not via this flag.)
variable "indexer_teardown_disarm" {
  type    = bool
  default = false
}
