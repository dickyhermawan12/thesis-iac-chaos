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

variable "vnet_address_space" {
  description = "Address spaces of the Virtual Network"
  type        = list(string)
}

variable "agw_subnet_address" {
  description = "Address spaces of the Subnet for application gateway"
  type        = list(string)
}

variable "jumpbox_subnet_address" {
  description = "Address spaces of the Subnet for jumpbox/ bastion host"
  type        = list(string)
}

variable "web_subnet_address" {
  description = "Address spaces of the Subnet for presentation/ web tier"
  type        = list(string)
}

variable "app_subnet_address" {
  description = "Address spaces of the Subnet for application tier"
  type        = list(string)
}

variable "db_subnet_address" {
  description = "Address spaces of the Subnet for database tier"
  type        = list(string)
}
