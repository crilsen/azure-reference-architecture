variable "name" {
  description = "Name of the virtual network."
  type        = string
}

variable "location" {
  description = "Azure region for the network."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group that holds the network."
  type        = string
}

variable "vnet_cidr" {
  description = "Address space of the virtual network."
  type        = string
}

variable "aks_subnet_cidr" {
  description = "Address prefix of the AKS node subnet."
  type        = string
}

variable "tags" {
  description = "Tags applied to network resources."
  type        = map(string)
  default     = {}
}
