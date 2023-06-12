output "resource_group_name" {
  value       = azurerm_resource_group.rg.name
  description = "Resource Group Name"
}

output "storage_account_name" {
  value       = azurerm_storage_account.sa.name
  description = "Storage Account Name"
}

output "storage_container_name" {
  value       = azurerm_storage_container.sc.name
  description = "Storage Container Name"
}
