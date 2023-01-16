

# resource "azurerm_virtual_wan" "vwan" {
#   name                = "vwanvpn"
#   resource_group_name = azurerm_resource_group.rg.name
#   location            = azurerm_resource_group.rg.location
# }

# resource "azurerm_virtual_hub" "virtualhub" {
#   name                = "virtualhubvpn"
#   resource_group_name = azurerm_resource_group.rg.name
#   location            = azurerm_resource_group.rg.location
#   virtual_wan_id      = azurerm_virtual_wan.vwan.id
#   address_prefix      = "10.50.200.0/24"
# }




# resource "azurerm_point_to_site_vpn_gateway" "vpngateway" {
#   name                        = "vpngateway"
#   location                    = azurerm_resource_group.rg.location
#   resource_group_name         = azurerm_resource_group.rg.name
#   virtual_hub_id              = azurerm_virtual_hub.virtualhub.id
#   vpn_server_configuration_id = azurerm_vpn_server_configuration.serverconfigvpn.id
#   scale_unit                  = 1

#   connection_configuration {
#     name = "vpnconfigcenata"
#     vpn_client_address_pool {
#       address_prefixes = [
#         "10.10.1.0/24"
#       ]
#     }
#   }
# }
# resource "azurerm_vpn_server_configuration" "serverconfigvpn" {
#   name                     = "servervpn"
#   resource_group_name      = azurerm_resource_group.rg.name
#   location                 = azurerm_resource_group.rg.location
#   vpn_protocols            = ["OpenVPN"]
#   vpn_authentication_types = ["AAD"]
#   azure_active_directory_authentication {
#     audience = "41b23e61-6c1e-4545-b367-cd054e0ed4b4"
#     issuer   = "https://sts.windows.net/345c1467-6246-4e71-a1d3-a73e906460a9/"
#     tenant   = "https://login.microsoftonline.com/345c1467-6246-4e71-a1d3-a73e906460a9/"

#   }
# }

 