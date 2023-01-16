
# resource "azurerm_cosmosdb_account" "cosmosdb" {
#   name                = var.cosmosdb-name
#   location            = azurerm_resource_group.rg.location
#   resource_group_name = azurerm_resource_group.rg.name
#   offer_type          = "Standard"
#   kind                = "GlobalDocumentDB"

#   consistency_policy {
#     consistency_level       = "BoundedStaleness"
#     max_interval_in_seconds = 10
#     max_staleness_prefix    = 200
#   }

#   geo_location {
#     location          = azurerm_resource_group.rg.location
#     failover_priority = 0

#   }
#   public_network_access_enabled = false
# }

# resource "azurerm_private_endpoint" "cosmosendpoint" {
#   name                = "cosmosdb-endpoint"
#   location            = azurerm_resource_group.rg.location
#   resource_group_name = azurerm_resource_group.rg.name
#   subnet_id           = azurerm_subnet.rg["PrivateEndpointSubnet"].id

#   private_service_connection {
#     name                           = "cosmosdb-privateserviceconnection"
#     private_connection_resource_id = azurerm_cosmosdb_account.cosmosdb.id
#     subresource_names              = ["SQL"]
#     is_manual_connection           = false
#   }
# }

# resource "azurerm_cosmosdb_sql_database" "cosmosdbsql" {
#   name                = "cenata-cosmos-mongo-db"
#   resource_group_name = azurerm_resource_group.rg.name
#   account_name        = azurerm_cosmosdb_account.cosmosdb.name
#   throughput          = 400
# }

# resource "azurerm_cosmosdb_sql_container" "cosmoscontainer" {

#   resource_group_name = azurerm_resource_group.rg.name
#   account_name        = azurerm_cosmosdb_account.cosmosdb.name
#   database_name       = azurerm_cosmosdb_sql_database.cosmosdbsql.name
#   name                = "cosmosdb_container"

#   partition_key_path = "/definition/id"
#   throughput         = 400
# }
