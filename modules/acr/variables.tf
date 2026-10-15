variable "name" {
  description = "Globally unique container registry name (alphanumeric only)."
  type        = string
}

variable "location" {
  description = "Azure region for the registry."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group that holds the registry."
  type        = string
}

variable "sku" {
  description = "Registry SKU (Basic, Standard, or Premium)."
  type        = string
  default     = "Standard"
}

variable "tags" {
  description = "Tags applied to the registry."
  type        = map(string)
  default     = {}
}
