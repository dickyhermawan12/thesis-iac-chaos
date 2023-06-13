variable "location" {
  description = "Location where resources will be created"
  type        = string
}

variable "tags" {
  description = "Tags to be applied to resources"
  type        = map(string)
}
