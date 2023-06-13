output "web_vmss_id" {
  description = "ID of the web VMSS"
  value       = azurerm_linux_virtual_machine_scale_set.web_vmss.id
}

output "app_vmss_id" {
  description = "ID of the app VMSS"
  value       = azurerm_linux_virtual_machine_scale_set.app_vmss.id
}
