output "nat_gateway_id" {
  description = "ID of the NAT Gateway"
  value       = azurerm_nat_gateway.natgw.id
}

output "nat_gateway_public_ip" {
  description = "Public IP address of the NAT Gateway"
  value       = azurerm_public_ip.natgw_public_ip.ip_address
}
