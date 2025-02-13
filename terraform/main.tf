#setting 
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.18.0"
    }
  }
}

terraform {
  backend "azurerm" {
    resource_group_name  = "Backend-Terraform-RG"
    storage_account_name = "vikashbackendstorage"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}

#azure provider
provider "azurerm" {
  features {
  }
  client_id       = var.ARM_CLIENT_ID
  client_secret   = var.ARM_CLIENT_SECRET
  tenant_id       = var.ARM_TENANT_ID
  subscription_id = var.ARM_SUBSCRIPTION_ID
}

#Resource block
resource "azurerm_resource_group" "my_demo_rg" {
  location = var.location
  name     = var.resource_group_name
}

resource "azurerm_virtual_network" "vnet" {
  name                = var.azurerm_virtual_network_name
  location            = var.location
  resource_group_name = azurerm_resource_group.my_demo_rg.name
  address_space       = ["10.0.0.0/16"]
}
resource "azurerm_subnet" "subnet" {
  name                 = "Terraform-Subnet"
  resource_group_name  = azurerm_resource_group.my_demo_rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}
resource "azurerm_network_interface" "nic" {
  name                = "Terraform-NIC"
  location            = azurerm_resource_group.my_demo_rg.location
  resource_group_name = azurerm_resource_group.my_demo_rg.name

  ip_configuration {
    name                          = "internal"
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.subnet.id
    public_ip_address_id          = azurerm_public_ip.pip.id
  }
}
resource "azurerm_public_ip" "pip" {
  name                = "Terraform-PIP"
  location            = azurerm_resource_group.my_demo_rg.location
  resource_group_name = azurerm_resource_group.my_demo_rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}
resource "azurerm_linux_virtual_machine" "Vm" {
  name                            = "terraformVM"
  location                        = azurerm_resource_group.my_demo_rg.location
  resource_group_name             = azurerm_resource_group.my_demo_rg.name
  size                            = "Standard_B1s"
  admin_username                  = "azureuser"
  admin_password                  = "vikash@123456"
  disable_password_authentication = false
  network_interface_ids           = [azurerm_network_interface.nic.id]
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

}
output "vm_public_ip" {
  value = azurerm_public_ip.pip.ip_address
}
