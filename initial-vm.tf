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


resource "azurerm_resource_group" "rg-vm" {
  name     = var.rg_vm_name
  location = var.rg_vm_location
}

resource "azurerm_virtual_network" "vnet" {
  name                = var.init_vnet_name
  location            = azurerm_resource_group.rg-vm.location
  resource_group_name = azurerm_resource_group.rg-vm.name
  address_space       = var.vnet_address_space
  tags = {
    environment = "Terraform test"
  }
}

resource "azurerm_subnet" "defaultSubnet" {
  name           = "defaultSubnet"
  resource_group_name = azurerm_resource_group.rg-vm.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes = ["10.0.1.0/24"]
}

resource "azurerm_network_interface" "vm_nic" {
  name                = "nic-${var.init_vm_name}"
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
  
  name                = var.init_vm_name
  resource_group_name = azurerm_resource_group.rg-vm.name
  location            = azurerm_resource_group.rg-vm.location
  size                = "Standard_B2MS"
  admin_username      = "adminuser"
  admin_password      = random_string.string.result
  
  network_interface_ids = [
    "${azurerm_resource_group.rg-vm.id}/providers/Microsoft.Network/networkInterfaces/nic-${var.init_vm_name}"
  ]

  
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsDesktop"
    offer     = "windows-10"
    sku       = "21h1-ent-g2"
    version   = "latest"
  }

  tags = {
    environment = "Production"
    hostpool = var.avd_workspace_name
  }
}