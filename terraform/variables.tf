variable "resource_group_name" {
  type = string
  default = "my-demo-rg2"
}
variable "location" {
  type = string
  default = "eastus"
}

variable "azurerm_virtual_network_name" {
  type = string
  default = "Terraform-Sample"
}


variable "ARM_CLIENT_ID" {}
variable "ARM_CLIENT_SECRET" {}
variable "ARM_TENANT_ID" {}
variable "ARM_SUBSCRIPTION_ID" {}