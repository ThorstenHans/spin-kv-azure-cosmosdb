output "account_name" {
  value = azurerm_cosmosdb_account.cosmos.name
}

output "database_name" {
  value = azurerm_cosmosdb_sql_database.db.name
}

output "container_name" {
  value = azurerm_cosmosdb_sql_container.container.name
}

output "key" {
  value     = azurerm_cosmosdb_account.cosmos.primary_key
  sensitive = true
}
