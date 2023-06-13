output "web_nsg_id" {
  description = "ID of the web NSG"
  value       = azurerm_network_security_group.web_nsg.id
}

output "app_nsg_id" {
  description = "ID of the app NSG"
  value       = azurerm_network_security_group.app_nsg.id
}

output "db_nsg_id" {
  description = "ID of the db NSG"
  value       = azurerm_network_security_group.db_nsg.id
}

output "jumpbox_nsg_id" {
  description = "ID of the jumpbox NSG"
  value       = azurerm_network_security_group.jumpbox_nsg.id
}
