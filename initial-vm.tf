terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "~>2.0"
    }
  }
}

provider "azurerm" {
  features {}

}

resource "random_string" "string" {
  length           = 16
  special          = true
  override_special = "/@£$"
}


resource "azurerm_resource_group" "rg-vm" {
  name     = var.rg_name
  location = var.rg_location
}

resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  location            = azurerm_resource_group.rg-vm.location
  resource_group_name = azurerm_resource_group.rg-vm.name
  address_space       = var.vnet_address_space
}

resource "azurerm_subnet" "defaultSubnet" {
  name           = var.vnet_subnet_name
  resource_group_name = azurerm_resource_group.rg-vm.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes = var.vnet_subnet_address
}

resource "azurerm_network_interface" "vm_nic" {
  name                = "nic-${var.vm_name}"
  location            = azurerm_resource_group.rg-vm.location
  resource_group_name = azurerm_resource_group.rg-vm.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.defaultSubnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "vm_init" {
  depends_on = [
      azurerm_network_interface.vm_nic
  ]
  
  name                = var.vm_name
  resource_group_name = azurerm_resource_group.rg-vm.name
  location            = azurerm_resource_group.rg-vm.location
  size                = var.vm_size
  admin_username      = "adminuser"
  admin_password      = random_string.string.result
  
  network_interface_ids = [
    "${azurerm_resource_group.rg-vm.id}/providers/Microsoft.Network/networkInterfaces/nic-${var.vm_name}"
  ]

  
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = var.vm_source_publisher
    offer     = var.vm_source_offer
    sku       = var.vm_source_sku
    version   = var.vm_source_version
  }

  tags = {
    environment = "Temp"
  }
}