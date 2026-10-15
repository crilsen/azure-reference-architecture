variable "name" {
  description = "Name of the AKS cluster."
  type        = string
}

variable "location" {
  description = "Azure region for the cluster."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group that holds the cluster."
  type        = string
}

variable "kubernetes_version" {
  description = "Kubernetes version for the control plane."
  type        = string
}

variable "dns_prefix" {
  description = "DNS prefix for the cluster API server."
  type        = string
}

variable "sku_tier" {
  description = "AKS SKU tier (Free, Standard, or Premium)."
  type        = string
  default     = "Free"
}

variable "node_count" {
  description = "Number of nodes in the system node pool."
  type        = number
  default     = 1
}

variable "node_vm_size" {
  description = "VM size for the system node pool."
  type        = string
  default     = "Standard_D2s_v3"
}

variable "vnet_subnet_id" {
  description = "Subnet where the node pool is placed."
  type        = string
}

variable "pod_cidr" {
  description = "Overlay CIDR for pod IPs. Must not overlap the VNet."
  type        = string
}

variable "service_cidr" {
  description = "CIDR for Kubernetes services. Must not overlap the VNet or pod CIDR."
  type        = string
}

variable "dns_service_ip" {
  description = "IP address for the cluster DNS service inside the service CIDR."
  type        = string
}

variable "log_analytics_workspace_id" {
  description = "Log Analytics workspace for the Container Insights add-on."
  type        = string
}

variable "tenant_id" {
  description = "Microsoft Entra tenant ID for Azure RBAC."
  type        = string
  sensitive   = true
}

variable "acr_id" {
  description = "Container registry the kubelet identity may pull from. Empty disables the assignment."
  type        = string
  default     = ""
}

variable "tags" {
  description = "Tags applied to the cluster."
  type        = map(string)
  default     = {}
}
