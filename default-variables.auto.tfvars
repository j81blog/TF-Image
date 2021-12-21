# In this file all variable values are stored.
# Initial Image settings
rg_name = "rg-weu-03-init-temp"
rg_location = "WestEurope"

vm_name = "vm-init"
vm_size = "Standard_B2MS"
vm_source_publisher = "MicrosoftWindowsDesktop"
vm_source_offer = "windows11preview"
vm_source_sku= "win11-21h2-avd"
vm_source_version = "latest"


# Virtual Network settings
vnet_name = "vnet-weu-03-init-vnet01"
vnet_address_space = ["10.3.16.0/21"]
vnet_subnet_name = "DefaultSubnet"
vnet_subnet_address = ["10.3.17.0/24"]
