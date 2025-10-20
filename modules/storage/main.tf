resource "azurerm_storage_account" "sa" {
  name                     = replace(lower("${var.name_prefix}${var.suffix}sa"), "-", "")
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  allow_nested_items_to_be_public = false
  min_tls_version                 = "TLS1_2"
  public_network_access_enabled   = true
  tags                            = var.tags

  # Single, permissive rule block
  network_rules {
    default_action = "Allow"
    bypass         = ["AzureServices"]
  }
}

resource "azurerm_storage_container" "tfstate" {
  name                  = "terraformstate"
  storage_account_name  = azurerm_storage_account.sa.name
  container_access_type = "private"
}

resource "azurerm_storage_container" "weblogs" {
  name                  = "weblogs"
  storage_account_name  = azurerm_storage_account.sa.name
  container_access_type = "private"
}
