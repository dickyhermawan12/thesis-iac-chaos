variable "prefix" {
  description = "Prefix for all resources created by terraform module"
  type        = string
  default     = "iac-thesis"
}

variable "tags" {
  description = "Tags for all resources created by terraform module"
  type        = map(string)
  default = {
    project = "iac-thesis"
  }
}

variable "location" {
  description = "Location where resources will be created"
  type        = string
  default     = "Southeast Asia"
}

variable "vnet_address_space" {
  description = "Address spaces of the Virtual Network"
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

variable "jumpbox_subnet_address" {
  description = "Address spaces of the Subnet for jumpbox/ bastion host"
  type        = list(string)
}

variable "app_lb_private_ip" {
  description = "Private IP of the app LB"
  type        = string
}

variable "mysql_db_username" {
  description = "Azure MySQL Database Administrator Username"
  type        = string
}

variable "mysql_db_password" {
  description = "Azure MySQL Database Administrator Password"
  type        = string
  sensitive   = true
}

variable "mysql_db_schema" {
  description = "Azure MySQL Database Schema Name"
  type        = string
}

variable "web_source_image_id" {
  description = "ID of the web source image"
  type        = string
}

variable "app_source_image_id" {
  description = "ID of the app source image"
  type        = string
}
