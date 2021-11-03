variable "rg_name" {
  type        = string
  description = "How is the resource group called"
}

variable "rg_location" {
  type        = string
  description = "What is the resource group location"
}

variable "vm_name" {
  type      = string
  description = "Enter the VM name"
}

variable "vm_size" {
  type      = string
  description = "Give a vm size like Standard_B2MS"
}

variable "vm_source_publisher" {
  type      = string
  description = "What is the image publisher"
}

variable "vm_source_offer" {
  type      = string
  description = "What is the image offer"
}

variable "vm_source_sku" {
  type        = string
  description = "What is the image sku"
}

variable "vm_source_version" {
  type      = string
  description = "What is the image version, latest?"
}


variable "vnet_name" {
  type        = string
  description = "What is the vnet name"
}

variable "vnet_address_space" {
  type        = list
  description = "What is the vnet address"
}

variable "vnet_subnet_name" {
  type        = string
  description = "How is the subnet called"
}

variable "vnet_subnet_address" {
  type        = list
  description = "What is the subnet address"
}
