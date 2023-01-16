
#  Create the SQL Server 
resource "azurerm_mssql_server" "cenata-sql-server" {
  name                          = "cenata787-sql-server-instance"
  resource_group_name           = azurerm_resource_group.rg.name
  location                      = azurerm_resource_group.rg.location
  version                       = "12.0"
  administrator_login           = var.sql_admin_login
  administrator_login_password  = azurerm_key_vault_secret.sql_secret.value
  public_network_access_enabled = false
  depends_on = [
  azurerm_key_vault_secret.sql_secret]
}

#  Create a the SQL database 
resource "azurerm_mssql_database" "cenata-sql-db" {

  depends_on     = [azurerm_mssql_server.cenata-sql-server]
  server_id      = azurerm_mssql_server.cenata-sql-server.id
  name           = "cenata-db"
  collation      = "Latin1_General_CI_AS"
  zone_redundant = false
  read_scale     = false
}


#  Create a DB Private Endpoint
resource "azurerm_private_endpoint" "cenata-db-endpoint" {
  depends_on          = [azurerm_mssql_server.cenata-sql-server]
  name                = "cenata-sql-db-endpoint"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = azurerm_subnet.rg["PrivateEndpointSubnet"].id


  private_service_connection {
    name                           = "cenata-sql-db-endpoint"
    is_manual_connection           = "false"
    private_connection_resource_id = azurerm_mssql_server.cenata-sql-server.id
    subresource_names              = ["sqlServer"]

  }


}

# # DB Private Endpoint Connecton
data "azurerm_private_endpoint_connection" "cenata-endpoint-connection" {
  depends_on          = [azurerm_private_endpoint.cenata-db-endpoint]
  name                = azurerm_private_endpoint.cenata-db-endpoint.name
  resource_group_name = azurerm_resource_group.rg.name

}



resource "azurerm_storage_account" "stor787" {
  name                     = var.storagestor
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}



resource "azurerm_storage_container" "storaccount" {
  name                  = var.storaccount-name
  storage_account_name  = azurerm_storage_account.stor787.name
  container_access_type = "private"
}

resource "azurerm_private_endpoint" "storageaccount" {
  name                = var.storaccount-name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = azurerm_subnet.rg["PrivateEndpointSubnet"].id



  private_service_connection {
    name                           = "${var.storaccount-name}-psc"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_storage_account.stor787.id
    subresource_names              = ["blob"]
  }

}