output "virtual_network_id" {
  description = "ID of the virtual network"
  value       = azurerm_virtual_network.vnet.id
}

output "agw_subnet_id" {
  description = "ID of the application gateway subnet"
  value       = azurerm_subnet.agw_subnet.id
}

output "jumpbox_subnet_id" {
  description = "ID of the jumpbox subnet"
  value       = azurerm_subnet.jumpbox_subnet.id
}

output "web_subnet_id" {
  description = "ID of the web subnet"
  value       = azurerm_subnet.web_subnet.id
}

output "app_subnet_id" {
  description = "ID of the app subnet"
  value       = azurerm_subnet.app_subnet.id
}

output "db_subnet_id" {
  description = "ID of the db subnet"
  value       = azurerm_subnet.db_subnet.id
}
