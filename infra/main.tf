resource "azurerm_resource_group" "rg" {
  name     = "rg-spin-cosmosdb"
  location = var.location
}

resource "random_integer" "suffix" {
  min = 1000
  max = 1999
}

resource "azurerm_cosmosdb_account" "cosmos" {
  name                = "cosmos-spin-${random_integer.suffix.result}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  offer_type          = "Standard"
  enable_free_tier    = true
  geo_location {
    location          = var.location
    failover_priority = 0
  }

  consistency_policy {
    consistency_level = "Strong"
  }
}
resource "azurerm_cosmosdb_sql_database" "db" {
  name                = "cosmos-sql-spin"
  resource_group_name = azurerm_resource_group.rg.name
  account_name        = azurerm_cosmosdb_account.cosmos.name
}

resource "azurerm_cosmosdb_sql_container" "container" {
  name                  = "kv"
  resource_group_name   = azurerm_resource_group.rg.name
  account_name          = azurerm_cosmosdb_account.cosmos.name
  database_name         = azurerm_cosmosdb_sql_database.db.name
  partition_key_path    = "/id"
  partition_key_version = 1

  autoscale_settings {
    max_throughput = 1000
  }
}
