terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.26"
    }
  }
}

provider "azurerm" {
  features {}
}

// resource group
resource "azurerm_resource_group" "lab_group" {
  name     = "lab_group"
  location = var.location
}

// network 
resource "azurerm_virtual_network" "lab_network" {
  name                = "lab_network"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = azurerm_resource_group.lab_group.name
}

# subnet
resource "azurerm_subnet" "lab_subnet" {
  name                 = "lab_subnet"
  resource_group_name  = azurerm_resource_group.name
  virtual_network_name = azurerm_virtual_network.lab_network.name
  address_prefix       = "10.0.1.0/24"
}

# public ip address 
resource "azurerm_public_ip" "web_server_ip" {
  name                = "web_server_ip"
  location            = var.location
  resource_group_name = azurerm_resource_group.lab_group.name
  allocation_method   = "Static"
}

# create network interface
resource "azurerm_network_interface" "web_server_nic" {
  name                = "web_server_nic"
  location            = var.location
  resource_group_name = azurerm_resource_group.lab_group.name

  ip_configuration {
    name                          = "web_server_nic_conf"
    subnet_id                     = azurerm_subnet.lab_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.web_server_ip.id
  }
}

# network security group 
resource "azurerm_network_security_group" "web_server_nsg" {
  name                = "web_server_nsg"
  location            = var.location
  resource_group_name = azurerm_resource_group.lab_group.name

  secuity_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inboud"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# linux VM
resource "azurerm_virtual_machine" "lab_web_server" {
  name                  = "lab_web_server"
  location              = var.location
  resource_group_name   = azurerm_resource_group.lab_group.name
  network_interface_ids = [azurerm_network_interface.web_server_nic.id]
  vm_size               = var.vm_size

  storage_os_disk {
    name              = "myOsDisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
  }

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04.0-LTS"
    version   = "latest"
  }

  os_profile {
    computer_name  = "lab_web_server"
    admin_username = var.admin_username
    admin_password = var.admin_password
    custom_data    = base64encode(data.template_file.linux-vm-cloud-init.rendered)
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }
}

data "template_file" "linux-vm-cloud-init" {
  template = file("linux-vm-cloud-init.sh")
}