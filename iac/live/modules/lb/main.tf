# Application Gateway to load balance traffic to the web servers
resource "azurerm_public_ip" "agw_public_ip" {
  name                = "${var.prefix}-agw-public-ip-1"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "Standard"
  allocation_method   = "Static"
  domain_name_label   = "iac-thesis-microblog"
  tags                = var.tags
}

resource "azurerm_application_gateway" "agw" {
  name                = "${var.prefix}-agw"
  resource_group_name = var.resource_group_name
  location            = var.location

  sku {
    name = "Standard_v2"
    tier = "Standard_v2"
  }

  autoscale_configuration {
    min_capacity = 1
    max_capacity = 2
  }

  gateway_ip_configuration {
    name      = "my-gateway-ip-configuration"
    subnet_id = var.agw_subnet_id
  }

  frontend_port {
    name = "agw-frontend-port"
    port = 80
  }

  frontend_ip_configuration {
    name                 = "agw-frontend-ip"
    public_ip_address_id = azurerm_public_ip.agw_public_ip.id
  }

  backend_address_pool {
    name = "agw-backend-pool"
  }

  backend_http_settings {
    name                  = "agw-http-settings"
    cookie_based_affinity = "Enabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 60
  }

  http_listener {
    name                           = "agw-http-listener"
    frontend_ip_configuration_name = "agw-frontend-ip"
    frontend_port_name             = "agw-frontend-port"
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = "agw-http-routing-rule"
    rule_type                  = "Basic"
    http_listener_name         = "agw-http-listener"
    backend_address_pool_name  = "agw-backend-pool"
    backend_http_settings_name = "agw-http-settings"
    priority                   = 1
  }
}

# resource "azurerm_lb" "web_lb" {
#   name                = "${var.prefix}-web-lb"
#   location            = var.location
#   resource_group_name = var.resource_group_name
#   sku                 = "Standard"

#   frontend_ip_configuration {
#     name                 = "web-lb-public-ip-1"
#     public_ip_address_id = azurerm_public_ip.web_lb_public_ip.id
#   }

#   tags = var.tags
# }

# resource "azurerm_lb_backend_address_pool" "web_lb_backend_pool" {
#   name            = "web-lb-backend-pool"
#   loadbalancer_id = azurerm_lb.web_lb.id
# }

# resource "azurerm_lb_probe" "web_lb_probe" {
#   name            = "tcp-probe"
#   protocol        = "Tcp"
#   port            = 80
#   loadbalancer_id = azurerm_lb.web_lb.id
# }

# resource "azurerm_lb_rule" "web_lb_rule" {
#   name                           = "web-lb-rule"
#   protocol                       = "Tcp"
#   frontend_port                  = 80
#   backend_port                   = 80
#   frontend_ip_configuration_name = azurerm_lb.web_lb.frontend_ip_configuration[0].name
#   backend_address_pool_ids       = [azurerm_lb_backend_address_pool.web_lb_backend_pool.id]
#   probe_id                       = azurerm_lb_probe.web_lb_probe.id
#   loadbalancer_id                = azurerm_lb.web_lb.id
# }

# Load balancer for the application servers

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
