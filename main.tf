locals {
  storage_account_name = lower("${var.product_name}dstoragedp")
  key_vault_name       = lower("${var.product_name}-d-keyvault-dp")
  data_factory_name    = lower("${var.product_name}-d-df")
  resource_group_name  = lower("${var.product_name}-d-rg")

}

module "data-platform" {
  storage_account_name = local.storage_account_name
  key_vault_name       = local.key_vault_name
  data_factory_name    = local.data_factory_name
  resource_group_name  = local.resource_group_name
  source               = "./data_platform"
}