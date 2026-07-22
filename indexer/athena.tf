resource "aws_glue_catalog_database" "rds_snapshots" {
  count = var.indexer_enabled ? 1 : 0
  name  = "rds_snapshots"
}
