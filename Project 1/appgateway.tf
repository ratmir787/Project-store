resource "azurerm_public_ip" "Appgateway_ip" {
  name                = "gateway-ip"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  allocation_method   = "Dynamic"


}

#   resource "azurerm_application_gateway" "app_gateway" {
#   name                = "app-gateway777"
#   resource_group_name = azurerm_resource_group.rg.name
#   location            = azurerm_resource_group.rg.location

#   sku {
#     name     = "Standard_Small"
#     tier     = "Standard"
#     capacity = 2
#   }
# }



# gateway_ip_configuration {
#     name      = "gateway-ip-config"
#     subnet_id = azurerm_virtual_network.rg.subnet.id
#   }

#   frontend_port {
#     name = "front-end-port"
#     port = 80
#   }

#  frontend_ip_configuration {
#     name                 = "front-end-ip-config"
#     public_ip_address_id = azurerm_public_ip.Appgateway_ip.id    
#   }


# // Here we ensure the virtual machines are added to the backend pool
# // of the Azure Application Gateway

# #   backend_address_pool{      
# #       name  = "videopool"
# #       ip_addresses = [
# #       "${azurerm_network_interface.app_interface1.private_ip_address}"
# #       ]
# #     }

# # backend_address_pool {
# #       name  = "imagepool"
# #       ip_addresses = [
# #       "${azurerm_network_interface.app_interface2.private_ip_address}"]

# # }