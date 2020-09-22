resource "azurerm_virtual_network" "vnet-demo" {
  name                = "vnet-demo"
  resource_group_name = var.resource_group
  location            = var.location
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "subnet-apps" {
  name                 = "subnet-apps"
  resource_group_name  = var.resource_group
  virtual_network_name = azurerm_virtual_network.vnet-demo.name
  address_prefixes     = ["10.0.1.0/24"]
}