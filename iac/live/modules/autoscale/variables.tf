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

variable "web_vmss_id" {
  description = "ID of the web VMSS where the autoscaling settings will be applied"
  type        = string
}

variable "app_vmss_id" {
  description = "ID of the app VMSS where the autoscaling settings will be applied"
  type        = string
}

variable "web_subnet_id" {
  description = "ID of the web subnet where the autoscaling settings will be applied"
  type        = string
}

variable "app_subnet_id" {
  description = "ID of the app subnet where the autoscaling settings will be applied"
  type        = string
}
