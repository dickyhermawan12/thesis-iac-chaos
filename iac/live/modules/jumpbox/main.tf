resource "azurerm_public_ip" "jumpbox_public_ip" {
  name                = "${var.prefix}-jumpbox-public-ip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Dynamic"
  domain_name_label   = "iac-thesis-poc-jumpbox"
  tags                = var.tags
}

resource "azurerm_network_interface" "jumpbox_nic" {
  name                = "${var.prefix}-jumpbox-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "jumpbox-nic-ip-config"
    subnet_id                     = var.jumpbox_subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.jumpbox_public_ip.id
  }

  tags = var.tags
}

resource "azurerm_linux_virtual_machine" "jumpbox_vm" {
  name                  = "${var.prefix}-jumpbox-vm"
  location              = var.location
  resource_group_name   = var.resource_group_name
  size                  = "Standard_B1ms"
  admin_username        = "dicky"
  network_interface_ids = [azurerm_network_interface.jumpbox_nic.id]

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

  tags = var.tags
}
