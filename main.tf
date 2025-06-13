resource "azurerm_resource_group" "mademi_rg" {
  name     = "testing-rg-mdm"
  location = "centralindia"
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

resource "azurerm_network_interface" "mademi_interface" {
  depends_on = [ azurerm_public_ip.mademi_pip ]
  name = "mdm-int"
  resource_group_name = azurerm_resource_group.mademi_rg.name
  location = azurerm_resource_group.mademi_rg.location
  ip_configuration {
    name = "mdm-ip"
    private_ip_address_allocation = "Dynamic"
    subnet_id = azurerm_subnet.mademi_subnet.id
    public_ip_address_id = azurerm_public_ip.mademi_pip.id
  }
}

resource "azurerm_virtual_machine" "mademi_vm" {
  name = "MDM-VM"
  resource_group_name = azurerm_resource_group.mademi_rg.name
  location = azurerm_resource_group.mademi_rg.location
  vm_size = "Standard_D2s_v3"
  network_interface_ids = [azurerm_network_interface.mademi_interface.id, azurerm_public_ip.mademi_pip.id]  
  storage_os_disk {
    name = "MDM-VM-DISK"
    caching = "ReadWrite"
    create_option = "FromImage"
  }
  storage_image_reference {
    publisher = "canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
  os_profile {
    computer_name = "MDM-TEST"
    admin_username = "mademi"
    admin_password = "Testing@54321"
  }  
  os_profile_linux_config {
    disable_password_authentication = false
  }
  delete_os_disk_on_termination = true
}












output "mademi_rg_id" {
  value = azurerm_resource_group.mademi_rg.id
}

output "mademi_rg_location" {
  value = azurerm_resource_group.mademi_rg.location
}

output "mademi_pip_id" {
  value = azurerm_public_ip.mademi_pip.ip_address
}

output "mademi_interface" {
  value = azurerm_network_interface.mademi_interface.id
}