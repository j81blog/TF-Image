variable "rg_name" {
  type        = string
  default     = "rg-temp-init"
}

variable "rg_location" {
  type        = string
  default     = "West Europe"
}

variable "init_vm_name" {
    type      = string
  default     = "vm-init"
  }

variable "init_vnet_name" {
  type        = string
  default     = "vnet-temp-init"
}

variable "vnet_nsg_name" {
  type        = string
  default     = "nsg-temp-init"
}

variable "vnet_address_space" {
  type        = list
  default     = ["10.0.0.0/16"]
}