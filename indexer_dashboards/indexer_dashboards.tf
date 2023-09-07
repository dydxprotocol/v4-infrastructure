module "indexer_dashboards" {
  count = 1

  source = "./modules/indexer_dashboards"

  indexer_services_variable_mapping = var.indexer_services_variable_mapping
}
