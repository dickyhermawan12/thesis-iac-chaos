resource "azurerm_network_security_group" "agw_nsg" {
  name                = "${var.prefix}-agw-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "inbound-rule-HTTP"
    description                = "Inbound Rule"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "inbound-rule-HTTPS"
    description                = "Inbound Rule"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "inbound-rule-65200-65535"
    description                = "Inbound Rule"
    priority                   = 102
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "65200-65535"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = var.tags
}

resource "azurerm_network_security_group" "jumpbox_nsg" {
  name                = "${var.prefix}-jumpbox-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "inbound-rule-SSH"
    description                = "Inbound Rule"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = var.tags
}

resource "azurerm_network_security_group" "web_nsg" {
  name                = "${var.prefix}-web-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "inbound-rule-HTTP"
    description                = "Inbound Rule"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "inbound-rule-SSH"
    description                = "Inbound Rule"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefixes    = concat(var.agw_subnet_address, var.jumpbox_subnet_address)
    destination_address_prefix = "*"
  }

  tags = var.tags
}

resource "azurerm_network_security_group" "app_nsg" {
  name                = "${var.prefix}-app-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "inbound-rule-HTTP"
    description                = "Inbound Rule"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefixes    = concat(var.web_subnet_address, var.jumpbox_subnet_address)
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "inbound-rule-SSH"
    description                = "Inbound Rule"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefixes    = var.jumpbox_subnet_address
    destination_address_prefix = "*"
  }

  tags = var.tags
}

resource "azurerm_network_security_group" "db_nsg" {
  name                = "${var.prefix}-db-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "inbound-rule-HTTP"
    description                = "Inbound Rule"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3306"
    source_address_prefixes    = concat(var.app_subnet_address, var.jumpbox_subnet_address)
    destination_address_prefix = "*"
  }

  tags = var.tags
}

resource "azurerm_subnet_network_security_group_association" "agw_nsg_assoc" {
  subnet_id                 = var.agw_subnet_id
  network_security_group_id = azurerm_network_security_group.agw_nsg.id
}

resource "azurerm_subnet_network_security_group_association" "jumpbox_nsg_assoc" {
  subnet_id                 = var.jumpbox_subnet_id
  network_security_group_id = azurerm_network_security_group.jumpbox_nsg.id
}

resource "azurerm_subnet_network_security_group_association" "web_nsg_assoc" {
  subnet_id                 = var.web_subnet_id
  network_security_group_id = azurerm_network_security_group.web_nsg.id
}

resource "azurerm_subnet_network_security_group_association" "app_nsg_assoc" {
  subnet_id                 = var.app_subnet_id
  network_security_group_id = azurerm_network_security_group.app_nsg.id
}

resource "azurerm_subnet_network_security_group_association" "db_nsg_assoc" {
  subnet_id                 = var.db_subnet_id
  network_security_group_id = azurerm_network_security_group.db_nsg.id
}
