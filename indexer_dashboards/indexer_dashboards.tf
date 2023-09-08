module "indexer_dashboards" {
  source                            = "../modules/indexer_dashboards"
  indexer_services_variable_mapping = var.indexer_services_variable_mapping
}
