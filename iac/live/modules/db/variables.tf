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

variable "db_subnet_id" {
  description = "ID of the db subnet where the autoscaling settings will be applied"
  type        = string
}

variable "mysql_db_username" {
  description = "Username for the MySQL database"
  type        = string
}

variable "mysql_db_password" {
  description = "Password for the MySQL database"
  type        = string
}
