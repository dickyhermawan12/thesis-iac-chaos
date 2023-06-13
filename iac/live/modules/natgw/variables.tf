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

variable "subnet_id" {
  description = "ID of the subnet where the NAT Gateway will be deployed"
  type        = string
}
