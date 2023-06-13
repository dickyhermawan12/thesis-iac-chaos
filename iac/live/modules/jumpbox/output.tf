output "jumpbox_public_ip_fqdn" {
  value = azurerm_public_ip.jumpbox_public_ip.fqdn
}

output "jumpbox_public_ip" {
  value = azurerm_public_ip.jumpbox_public_ip.ip_address
}
