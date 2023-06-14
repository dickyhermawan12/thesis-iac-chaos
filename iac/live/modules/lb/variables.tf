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

variable "agw_subnet_id" {
  description = "ID of the agw subnet for the application gateway"
  type        = string
}

variable "app_lb_private_ip" {
  description = "Private IP of the app LB"
  type        = string
}
