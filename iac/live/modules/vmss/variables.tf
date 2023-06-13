variable "prefix" {
  description = "Prefix for all resources created by terraform module"
  type        = string
}

variable "tags" {
  description = "Tags for all resources created by terraform module"
  type        = map(string)
}

variable "location" {
  description = "Location where resources will be created"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group where resources will be created"
  type        = string
}

variable "web_nsg_id" {
  description = "ID of the web NSG where the VMSS will be deployed"
  type        = string
}

variable "app_nsg_id" {
  description = "ID of the app NSG where the VMSS will be deployed"
  type        = string
}

variable "web_subnet_id" {
  description = "ID of the web subnet where the VMSS will be deployed"
  type        = string
}

variable "app_subnet_id" {
  description = "ID of the app subnet where the VMSS will be deployed"
  type        = string
}

variable "db_subnet_id" {
  description = "ID of the db subnet where the VMSS will be deployed"
  type        = string
}

variable "web_lb_backend_address_pool_id" {
  description = "ID of the web LB backend pool where the VMSS will be deployed"
  type        = string
}

variable "app_lb_backend_address_pool_id" {
  description = "ID of the app LB backend pool where the VMSS will be deployed"
  type        = string
}
