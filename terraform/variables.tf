variable "resource_group_name" {
  type = string
  default = "my-demo-rg1"
}
variable "location" {
  type = string
  default = "eastus"
}

variable "azurerm_virtual_network_name" {
  type = string
  default = "Terraform-Sample"
}