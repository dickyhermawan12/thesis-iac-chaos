# Web tier

resource "azurerm_public_ip" "web_lb_public_ip" {
  name                = "${var.prefix}-web-lb-public-ip-1"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "Standard"
  allocation_method   = "Static"
  domain_name_label   = "iac-thesis-microblog"
  tags                = var.tags
}

resource "azurerm_lb" "web_lb" {
  name                = "${var.prefix}-web-lb"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                 = "web-lb-public-ip-1"
    public_ip_address_id = azurerm_public_ip.web_lb_public_ip.id
  }

  tags = var.tags
}

resource "azurerm_lb_backend_address_pool" "web_lb_backend_pool" {
  name            = "web-lb-backend-pool"
  loadbalancer_id = azurerm_lb.web_lb.id
}

resource "azurerm_lb_probe" "web_lb_probe" {
  name            = "tcp-probe"
  protocol        = "Tcp"
  port            = 80
  loadbalancer_id = azurerm_lb.web_lb.id
}

resource "azurerm_lb_rule" "web_lb_rule" {
  name                           = "web-lb-rule"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = azurerm_lb.web_lb.frontend_ip_configuration[0].name
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.web_lb_backend_pool.id]
  probe_id                       = azurerm_lb_probe.web_lb_probe.id
  loadbalancer_id                = azurerm_lb.web_lb.id
}

# App tier

resource "azurerm_lb" "app_lb" {
  name                = "${var.prefix}-app-lb"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                          = "app-lb-private-ip-1"
    subnet_id                     = var.app_subnet_id
    private_ip_address_allocation = "Static"
    private_ip_address_version    = "IPv4"
    private_ip_address            = var.app_lb_private_ip
  }
}

resource "azurerm_lb_backend_address_pool" "app_lb_backend_pool" {
  name            = "app-lb-backend-pool"
  loadbalancer_id = azurerm_lb.app_lb.id
}

resource "azurerm_lb_probe" "app_lb_probe" {
  name            = "tcp-probe"
  protocol        = "Tcp"
  port            = 80
  loadbalancer_id = azurerm_lb.app_lb.id
}

resource "azurerm_lb_rule" "app_lb_rule" {
  name                           = "app-lb-rule"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = azurerm_lb.app_lb.frontend_ip_configuration[0].name
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.app_lb_backend_pool.id]
  probe_id                       = azurerm_lb_probe.app_lb_probe.id
  loadbalancer_id                = azurerm_lb.app_lb.id
}
