locals {
  frontend_ip_configuration_name = "agw-frontend-ip"
  redirect_configuration_name    = "agw-redirect-config"
  backend_address_pool_name      = "agw-backend-pool"
  http_setting_name              = "agw-http-settings"

  # HTTP Listener -  Port 80
  listener_name_http             = "agw-http-listener"
  request_routing_rule_name_http = "agw-http-routing-rule"
  frontend_port_name_http        = "agw-http-frontend-port"

  # HTTPS Listener -  Port 443
  listener_name_https             = "agw-https-listener"
  request_routing_rule_name_https = "agw-https-routing-rule"
  frontend_port_name_https        = "agw-https-frontend-port"
  ssl_certificate_name            = "microblog-cert-1"
}

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
  tags                = var.tags

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
    name = local.frontend_port_name_http
    port = 80
  }

  frontend_port {
    name = local.frontend_port_name_https
    port = 443
  }

  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.agw_public_ip.id
  }

  backend_address_pool {
    name = local.backend_address_pool_name
  }

  backend_http_settings {
    name                  = local.http_setting_name
    cookie_based_affinity = "Enabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 60
  }

  # Listener on Port 80 (HTTP)
  http_listener {
    name                           = local.listener_name_http
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = local.frontend_port_name_http
    protocol                       = "Http"
  }

  # Routing rule from HTTP to HTTPS
  request_routing_rule {
    name                        = local.request_routing_rule_name_http
    rule_type                   = "Basic"
    http_listener_name          = local.listener_name_http
    redirect_configuration_name = local.redirect_configuration_name
    priority                    = 1
  }

  # Redirect configuration for HTTP to HTTPS
  redirect_configuration {
    name                 = local.redirect_configuration_name
    redirect_type        = "Permanent"
    target_listener_name = local.listener_name_https
    include_path         = true
    include_query_string = true
  }

  ssl_certificate {
    name     = local.ssl_certificate_name
    password = "iacthesis"
    data     = filebase64("${path.root}/letsencrypt/iac-thesis-microblog.pfx")
  }

  # Listener on Port 443 (HTTPS)
  http_listener {
    name                           = local.listener_name_https
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = local.frontend_port_name_https
    protocol                       = "Https"
    ssl_certificate_name           = local.ssl_certificate_name
  }

  request_routing_rule {
    name                       = local.request_routing_rule_name_https
    rule_type                  = "Basic"
    http_listener_name         = local.listener_name_https
    backend_address_pool_name  = local.backend_address_pool_name
    backend_http_settings_name = local.http_setting_name
    priority                   = 2
  }
}

resource "azurerm_lb" "app_lb" {
  name                = "${var.prefix}-app-lb"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "Standard"
  tags                = var.tags

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
