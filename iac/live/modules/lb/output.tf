output "agw_public_ip_address" {
  description = "The Public IP Address associated with the Application Gateway"
  value       = azurerm_public_ip.agw_public_ip.ip_address
}

output "agw_public_ip_fqdn" {
  description = "The FQDN associated with the Public IP Address"
  value       = azurerm_public_ip.agw_public_ip.fqdn
}

output "agw_backend_address_pool_id" {
  description = "The Backend Address Pool associated with the Application Gateway"
  value       = tolist(azurerm_application_gateway.agw.backend_address_pool).0.id
}

# output "web_lb_id" {
#   description = "The ID of the Internet Load Balancer"
#   value       = azurerm_lb.web_lb.id
# }

# output "web_lb_frontend_ip_configuration" {
#   description = "The Frontend IP Configuration associated with the Internal Load Balancer"
#   value       = [azurerm_lb.web_lb.frontend_ip_configuration]
# }

# output "web_lb_backend_address_pool_id" {
#   description = "The Frontend Address Pool ID associated with the Internet Load Balancer"
#   value       = azurerm_lb_backend_address_pool.web_lb_backend_pool.id
# }

output "app_lb_private_ip_addresses" {
  description = "The Private IP Addresses associated with the Internal Load Balancer"
  value       = [azurerm_lb.app_lb.private_ip_addresses]
}

output "app_lb_id" {
  description = "The ID of the Internal Load Balancer"
  value       = azurerm_lb.app_lb.id
}

output "app_lb_frontend_ip_configuration" {
  description = "The Frontend IP Configuration associated with the Internal Load Balancer"
  value       = [azurerm_lb.app_lb.frontend_ip_configuration]
}

output "app_lb_backend_address_pool_id" {
  description = "The Backend Address Pool ID associated with the Internal Load Balancer"
  value       = azurerm_lb_backend_address_pool.app_lb_backend_pool.id
}
