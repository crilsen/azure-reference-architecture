variable "name" {
  description = "Name of the user-assigned managed identity."
  type        = string
}

variable "location" {
  description = "Azure region for the identity."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group that holds the identity."
  type        = string
}

variable "oidc_issuer_url" {
  description = "OIDC issuer URL exposed by the AKS cluster."
  type        = string
}

variable "namespace" {
  description = "Kubernetes namespace of the workload service account."
  type        = string
}

variable "service_account_name" {
  description = "Kubernetes service account bound to the identity."
  type        = string
}

variable "tags" {
  description = "Tags applied to the identity."
  type        = map(string)
  default     = {}
}
