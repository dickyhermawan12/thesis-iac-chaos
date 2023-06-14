output "agw_public_ip" {
  value = module.lb.agw_public_ip_address
}

output "agw_public_ip_fqdn" {
  value = module.lb.agw_public_ip_fqdn
}

output "jumpbox_public_ip_fqdn" {
  value = module.jumpbox.jumpbox_public_ip_fqdn
}

output "jumpbox_public_ip" {
  value = module.jumpbox.jumpbox_public_ip
}
