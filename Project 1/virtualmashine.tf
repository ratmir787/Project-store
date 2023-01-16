



# resource "azurerm_network_interface" "vm-nic" {
#   name                = "vm_nic"
#   location            = azurerm_resource_group.rg.location
#   resource_group_name = azurerm_resource_group.rg.name



#   ip_configuration {
#     name                          = "internal"
#     subnet_id                     = azurerm_subnet.rg["VpnGatewaySubnet"].id
#     private_ip_address_allocation = "Dynamic"
#     public_ip_address_id          = azurerm_public_ip.Appgateway_ip.id

#   }
# }

# resource "azurerm_windows_virtual_machine" "windows10" {
#   name                = "winpc10"
#   resource_group_name = azurerm_resource_group.rg.name
#   location            = azurerm_resource_group.rg.location
#   size                = "Standard_F2"
#   admin_username      = "adminuser"
#   admin_password      = "aZrtmp102-754"
#   network_interface_ids = [
#     azurerm_network_interface.vm-nic.id,
#   ]

#   os_disk {
#     caching              = "ReadWrite"
#     storage_account_type = "Standard_LRS"
#   }

#   source_image_reference {
#     publisher = "MicrosoftWindowsServer"
#     offer     = "WindowsServer"
#     sku       = "2016-Datacenter"
#     version   = "latest"
#   }

# }