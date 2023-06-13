resource "azurerm_linux_virtual_machine_scale_set" "web_vmss" {
  name                = "${var.prefix}-web-vmss"
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "Standard_B1s"
  instances           = 1
  admin_username      = "dicky"

  admin_ssh_key {
    username   = "dicky"
    public_key = file("${path.module}/../ssh-keys/iac-thesis.pub")
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  upgrade_mode = "Automatic"

  network_interface {
    name                      = "web-vmss-nic"
    primary                   = true
    network_security_group_id = var.web_nsg_id

    ip_configuration {
      name                                   = "web-vmss-ip-config"
      primary                                = true
      subnet_id                              = var.web_subnet_id
      load_balancer_backend_address_pool_ids = [var.web_lb_backend_address_pool_id]
    }
  }

  custom_data = base64encode(file("${path.module}/custom-data/web-vmss.sh"))
}

resource "azurerm_linux_virtual_machine_scale_set" "app_vmss" {
  name                = "${var.prefix}-app-vmss"
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "Standard_B1s"
  instances           = 1
  admin_username      = "dicky"

  admin_ssh_key {
    username   = "dicky"
    public_key = file("${path.module}/../ssh-keys/iac-thesis.pub")
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  upgrade_mode = "Automatic"

  network_interface {
    name                      = "app-vmss-nic"
    primary                   = true
    network_security_group_id = var.app_nsg_id

    ip_configuration {
      name                                   = "app-vmss-ip-config"
      primary                                = true
      subnet_id                              = var.app_subnet_id
      load_balancer_backend_address_pool_ids = [var.app_lb_backend_address_pool_id]
    }
  }

  custom_data = base64encode(file("${path.module}/custom-data/app-vmss.sh"))
}
