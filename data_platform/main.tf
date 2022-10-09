
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_key_vault" "kv" {
  name                        = var.key_vault_name
  location                    = var.location
  resource_group_name         = var.resource_group_name
  enabled_for_disk_encryption = true
  tenant_id                   = var.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"

  depends_on = [
    azurerm_resource_group.rg
  ]
}


resource "azurerm_storage_account" "sa" {
  name                     = var.storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
  is_hns_enabled           = "true"


  blob_properties {
    delete_retention_policy {
      days = 7
    }
    container_delete_retention_policy {
      days = 7
    }
  }

  identity {
    type = "SystemAssigned"
  }

  depends_on = [
    azurerm_resource_group.rg
  ]

}

resource "azurerm_storage_data_lake_gen2_filesystem" "datalake" {
  name               = "data"
  storage_account_id = azurerm_storage_account.sa.id

  properties = {
    hello = "aGVsbG8="
  }

  depends_on = [
    azurerm_storage_account.sa
  ]
}


resource "azurerm_data_factory" "df" {
  name                = var.data_factory_name
  location            = var.location
  resource_group_name = var.resource_group_name

  identity {
    type = "SystemAssigned"
  }
  depends_on = [
    azurerm_key_vault.kv,
    azurerm_storage_account.sa
  ]
}

resource "azurerm_data_factory_linked_service_data_lake_storage_gen2" "dl" {
  name                 = "LS_SA_${var.storage_account_name}"
  data_factory_id      = azurerm_data_factory.df.id
  use_managed_identity = true
  url                  = azurerm_storage_account.sa.primary_dfs_endpoint
}

resource "azurerm_data_factory_linked_service_key_vault" "ls_kv" {
  name            = "LS_KV_${var.key_vault_name}"
  data_factory_id = azurerm_data_factory.df.id
  key_vault_id    = azurerm_key_vault.kv.id
}

