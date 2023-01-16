terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.24.0"
    }
  }
}

provider "azurerm" {
  skip_provider_registration = true
  client_id                  = var.CLIENT_ID
  client_secret              = var.CLIENT_SECRET
  subscription_id            = var.subscribtionID
  tenant_id                  = var.TENANT_ID
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}


resource "azurerm_resource_group" "rg" {
  name     = var.resourceGroupName
  location = var.location
}

data "azurerm_client_config" "current" {}


# DATA #
data "azurerm_resource_group" "rg" {
  name = azurerm_resource_group.rg.name
}

# RESOURCES #
resource "azurerm_virtual_network" "rg" {
  name                = var.vnet_name
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  address_space       = var.vnet_address_space
  
  tags = {
    environment = "RatmirProject"
  }
}

resource "azurerm_subnet" "rg" {
  for_each                                  = var.subnets
  name                                      = lookup(each.value, "name")
  resource_group_name                       = data.azurerm_resource_group.rg.name
  virtual_network_name                      = azurerm_virtual_network.rg.name
  address_prefixes                          = [lookup(each.value, "cidr")]
  private_endpoint_network_policies_enabled = true
  
  # delegation {
  #   name = "Microsoft.Web"

  #   service_delegation {
  #     name    = "Microsoft.Web/serverFarms"
  #     actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
  
#   #   }
# }


}

locals {
  azurerm_subnets = {
    for index, subnet in azurerm_subnet.rg :
    subnet.name => subnet.id }
  }

  
resource "azurerm_network_security_group" "rg" {
  name                = var.nsg_name
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  

  security_rule {
    name                       = "ManagementEndpoint"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }


  security_rule {
    name                       = "rdpendpoint"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

}

resource "azurerm_subnet_network_security_group_association" "rg" {

  for_each  = var.nsg_ids
  subnet_id = local.azurerm_subnets[each.key]

  network_security_group_id = azurerm_network_security_group.rg.id

}






# # Create a Private DNS Zone
resource "azurerm_private_dns_zone" "sql-private-dns" {
  name                = var.sql-private-dns
  resource_group_name = data.azurerm_resource_group.rg.name
}
# Link the Private DNS Zone with the VNET
resource "azurerm_private_dns_zone_virtual_network_link" "sql-private-dns-link" {
  name                  = "sql-vnet"
  resource_group_name   = data.azurerm_resource_group.rg.name
  private_dns_zone_name = azurerm_private_dns_zone.sql-private-dns.name
  virtual_network_id    = azurerm_virtual_network.rg.id
}
# Create a DB Private DNS Zone
resource "azurerm_private_dns_zone" "cenata-endpoint-dns-private-zone" {
  name                = "${var.sql-dns-privatelink}.database.windows.net"
  resource_group_name = data.azurerm_resource_group.rg.name

}


# Create a DB Private DNS A Record
resource "azurerm_private_dns_a_record" "cenata-endpoint-dns-a-record" {
  depends_on          = [azurerm_mssql_server.cenata-sql-server]
  name                = lower(azurerm_mssql_server.cenata-sql-server.name)
  zone_name           = azurerm_private_dns_zone.cenata-endpoint-dns-private-zone.name
  resource_group_name = azurerm_resource_group.rg.name
  ttl                 = 300
  records             = [data.azurerm_private_endpoint_connection.cenata-endpoint-connection.private_service_connection.0.private_ip_address]
}
# Create a Private DNS to VNET link
resource "azurerm_private_dns_zone_virtual_network_link" "dns-zone-to-vnet-link" {
  name                  = "cenata-sql-db-vnet-link"
  resource_group_name   = azurerm_resource_group.rg.name
  private_dns_zone_name = azurerm_private_dns_zone.cenata-endpoint-dns-private-zone.name
  virtual_network_id    = azurerm_virtual_network.rg.id
}






resource "azurerm_key_vault" "keyvault_test" {
  name                        = "keyvault776655"
  location                    = azurerm_resource_group.rg.location
  resource_group_name         = azurerm_resource_group.rg.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Create",
      "Get"
    ]

    secret_permissions = [
      "Set",
      "Get",
      "Delete",
      "Purge",
      "Recover"
    ]

    storage_permissions = [
      "Get",

    ]
  }

  depends_on = [
  azurerm_resource_group.rg]
}

resource "azurerm_key_vault_secret" "sql_secret" {
  name         = "sqladminpass"
  value        = var.sql_admin_password
  key_vault_id = azurerm_key_vault.keyvault_test.id


  depends_on = [
  azurerm_resource_group.rg]

}