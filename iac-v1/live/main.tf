terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.59.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "iac-thesis-rg"
    storage_account_name = "iacthesissa"
    container_name       = "iac-container"
    key                  = "live.terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}

data "terraform_remote_state" "bootstrap" {
  backend = "azurerm"

  config = {
    resource_group_name  = "iac-thesis-rg"
    storage_account_name = "iacthesissa"
    container_name       = "iac-container"
    key                  = "bootstrap.terraform.tfstate"
  }
}

# Virtual Network

resource "azurerm_virtual_network" "vmss" {
  name                = "vmss-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = data.terraform_remote_state.bootstrap.outputs.resource_group_name
  tags                = var.tags
}

resource "azurerm_subnet" "vmss" {
  name                 = "vmss-subnet"
  resource_group_name  = data.terraform_remote_state.bootstrap.outputs.resource_group_name
  virtual_network_name = azurerm_virtual_network.vmss.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_public_ip" "vmss" {
  name                = "vmss-public-ip"
  location            = var.location
  resource_group_name = data.terraform_remote_state.bootstrap.outputs.resource_group_name
  allocation_method   = "Static"
  domain_name_label   = "iac-thesis-poc"
  tags                = var.tags
}

resource "azurerm_lb" "vmss" {
  name                = "vmss-lb"
  location            = var.location
  resource_group_name = data.terraform_remote_state.bootstrap.outputs.resource_group_name

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.vmss.id
  }

  tags = var.tags
}

resource "azurerm_lb_backend_address_pool" "bpepool" {
  loadbalancer_id = azurerm_lb.vmss.id
  name            = "BackEndAddressPool"
}

resource "azurerm_lb_probe" "vmss" {
  loadbalancer_id = azurerm_lb.vmss.id
  name            = "ssh-running-probe"
  port            = var.application_port
}

resource "azurerm_lb_rule" "lbnatrule" {
  loadbalancer_id                = azurerm_lb.vmss.id
  name                           = "http"
  protocol                       = "Tcp"
  frontend_port                  = var.application_port
  backend_port                   = var.application_port
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.bpepool.id]
  frontend_ip_configuration_name = "PublicIPAddress"
  probe_id                       = azurerm_lb_probe.vmss.id
}

resource "azurerm_virtual_machine_scale_set" "vmss" {
  name                = "vmscaleset"
  location            = var.location
  resource_group_name = data.terraform_remote_state.bootstrap.outputs.resource_group_name
  upgrade_policy_mode = "Manual"

  sku {
    name     = "Standard_DS1_v2"
    tier     = "Standard"
    capacity = 2
  }

  storage_profile_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  storage_profile_os_disk {
    name              = ""
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_profile_data_disk {
    lun           = 0
    caching       = "ReadWrite"
    create_option = "Empty"
    disk_size_gb  = 10
  }

  os_profile {
    computer_name_prefix = "vmlab"
    admin_username       = var.admin_user
    admin_password       = var.admin_password
    custom_data          = file("web.conf")
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  network_profile {
    name    = "terraformnetworkprofile"
    primary = true

    ip_configuration {
      name                                   = "IPConfiguration"
      subnet_id                              = azurerm_subnet.vmss.id
      load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.bpepool.id]
      primary                                = true
    }
  }

  tags = var.tags
}

resource "azurerm_public_ip" "jumpbox" {
  name                = "jumpbox-public-ip"
  location            = var.location
  resource_group_name = data.terraform_remote_state.bootstrap.outputs.resource_group_name
  allocation_method   = "Static"
  domain_name_label   = "iac-thesis-poc-ssh"
  tags                = var.tags
}

resource "azurerm_network_interface" "jumpbox" {
  name                = "jumpbox-nic"
  location            = var.location
  resource_group_name = data.terraform_remote_state.bootstrap.outputs.resource_group_name

  ip_configuration {
    name                          = "IPConfiguration"
    subnet_id                     = azurerm_subnet.vmss.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.jumpbox.id
  }

  tags = var.tags
}

resource "azurerm_virtual_machine" "jumpbox" {
  name                  = "jumpbox"
  location              = var.location
  resource_group_name   = data.terraform_remote_state.bootstrap.outputs.resource_group_name
  network_interface_ids = [azurerm_network_interface.jumpbox.id]
  vm_size               = "Standard_DS1_v2"

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = "jumpbox-osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "jumpbox"
    admin_username = var.admin_user
    admin_password = var.admin_password
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  tags = var.tags
}
