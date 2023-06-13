output "web_lb_public_ip_fqdn" {
  value = module.lb.web_lb_public_ip_fqdn
}

output "jumpbox_public_ip_fqdn" {
  value = module.jumpbox.jumpbox_public_ip_fqdn
}

output "jumpbox_public_ip" {
  value = module.jumpbox.jumpbox_public_ip
}
