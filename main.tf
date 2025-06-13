resource "azurerm_resource_group" "mademi_rg" {
  name     = "deepak-rg"
  location = "eastus"
}

resource "azurerm_virtual_network" "mademi_vnet" {
  name                = "vnet-1-mademi"
  location            = "centralindia"
  resource_group_name = azurerm_resource_group.mademi_rg.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "mademi_subnet" {
  name                 = "subnet-1-mademi"
  resource_group_name  = azurerm_resource_group.mademi_rg.name
  virtual_network_name = azurerm_virtual_network.mademi_vnet.name
  address_prefixes     = ["10.0.10.0/24"]
}

resource "azurerm_public_ip" "mademi_pip" {
  name                = "pip_mademi"
  location            = azurerm_resource_group.mademi_rg.location
  sku                 = "Basic"
  allocation_method   = "Dynamic"
  resource_group_name = azurerm_resource_group.mademi_rg.name
}

resource "azurerm_resource_group" "mademi_rg" {
  name     = "deepak-rg1"
  location = "eastus"
}












output "mademi_rg_id" {
  value = azurerm_resource_group.mademi_rg.id
}

output "mademi_rg_location" {
  value = azurerm_resource_group.mademi_rg.location
}