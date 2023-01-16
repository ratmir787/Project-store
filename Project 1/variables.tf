variable "subscribtionID" {
  type        = string
  description = "Variable for our resource group"
}

variable "resourceGroupName" {
  type        = string
  description = "name of resource group"
}

variable "resourceGroupNameNet" {
  type        = string
  description = "name of network"

}

variable "CLIENT_ID" {
  type        = string
  description = "appid"
}

variable "CLIENT_SECRET" {
  type        = string
  description = "pass"
}

variable "TENANT_ID" {
  type        = string
  description = "pass"
}

variable "storagestor" {
  type        = string
  description = "pass"
}
variable "location" {
  type        = string
  description = "location of your resource group"
}


variable "resourceSQLServer" {
  type        = string
  description = "name of SQL Server"
}


variable "database1" {
  type        = string
  description = "name of main database"

}

variable "sql_admin_login" {
  type = string
}

variable "sql_admin_password" {
  type = string
}

variable "keyvaultname" {
  type = string
}


variable "vnet_name" {
  type = string
}


variable "vnet_address_space" {
  description = "The address space that is used the virtual network. You can supply more than one address space."
  type        = list(string)
  default     = ["10.50.0.0/16"]
}

variable "subnets" {


  type = map(object({
    name = string
    cidr = string
    id   = string

  }))


  default = {
    ApiSubnet = {
      name = "ApiSubnet"
      cidr = "10.50.1.0/24"
      id   = "name"
    }
    FunctionSubnet = {
      name = "FunctionSubnet"
      cidr = "10.50.2.0/24"
      id   = "name"
    }
    PrivateEndpointSubnet = {
      name = "PrivateEndpointSubnet"
      cidr = "10.50.3.0/24"
      id   = "name"
    }
    VpnGatewaySubnet = {
      name = "VpnGatewaySubnet"
      cidr = "10.50.200.0/24"
      id   = "name"
    }

  }
}


variable "nsg_name" {
  description = "NSG name"
  type        = string
  default     = "nsg"
}


variable "nsg_ids" {
  description = "A map of subnet name to Network Security Group IDs"
  type        = map(string)

  default = {
    ApiSubnet             = "nsg"
    FunctionSubnet        = "nsg"
    PrivateEndpointSubnet = "nsg"
    VpnGatewaySubnet      = "nsg"

  }
}



variable "sql-private-dns" {
  type        = string
  description = "The private DNS name"
}
variable "sql-dns-privatelink" {
  type        = string
  description = "SQL DNS Private Link"
}

variable "cosmosdb-name" {
  type = string
}
variable "storaccount-name" {
  type = string
}

variable "appserviceplan" {
  type = string
}
variable "appservicename" {
  type = string

}
variable "function-app" {
  type = string

}

variable "api-management-name" {
  type = string

}


