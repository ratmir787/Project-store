

resource "azurerm_service_plan" "appserviceplan" {
  name                = var.appserviceplan
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  os_type             = "Linux"
  sku_name            = "B1"



}


resource "azurerm_linux_web_app" "app" {
  name                = var.appservicename
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  service_plan_id     = azurerm_service_plan.appserviceplan.id

  site_config {


  }

  app_settings = {
    "SOME_KEY" = "some-value"
  }

  connection_string {
    name  = "AZURE_SQL_CONNECTIONSTRING"
    type  = "SQLAzure"
    value = "Server=tcp:cenata787-sql-server-instance.database.windows.net Database=azurerm_sql_database.db.namecenata-db;User ID=var.sql_admin_login;Password=[azurerm_key_vault_secret.sql_secret].value;Trusted_Connection=False;Encrypt=True;"
  }



}
resource "azurerm_linux_function_app" "linuxapp" {
  name                       = var.function-app
  location                   = azurerm_resource_group.rg.location
  resource_group_name        = azurerm_resource_group.rg.name
  service_plan_id            = azurerm_service_plan.appserviceplan.id
  storage_account_name       = azurerm_storage_account.stor787.name
  storage_account_access_key = azurerm_storage_account.stor787.primary_access_key
  virtual_network_subnet_id  = azurerm_subnet.rg["FunctionSubnet"].id


   
  
  site_config {
    # vnet_route_all_enabled = " true"

  }
}














resource "azurerm_api_management" "apimanagement77" {
  name                = var.api-management-name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  publisher_name      = "CenataTest"
  publisher_email     = "cenatatest@terraform.io"
  gateway_disabled    = "false"



  sku_name             = "Developer_1"
  virtual_network_type = "Internal"


  virtual_network_configuration {
    subnet_id = azurerm_subnet.rg["ApiSubnet"].id


    # depends_on = [azurerm_subnet.rg]
    #  management_ip = "10.50.1.10/24"



  }

}





