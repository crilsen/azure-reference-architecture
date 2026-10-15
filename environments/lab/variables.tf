variable "tenant_id" {
  description = "Microsoft Entra tenant ID."
  type        = string
  sensitive   = true
}

variable "subscription_id" {
  description = "Existing Lab subscription ID used for workloads."
  type        = string
  sensitive   = true
}

variable "azure_location" {
  description = "Azure region used by the lab."
  type        = string
}

variable "project_name" {
  description = "Generic prefix for Azure lab resources."
  type        = string
}

variable "kubernetes_version" {
  description = "Kubernetes version for AKS."
  type        = string
}

variable "vnet_cidr" {
  description = "Address range for the lab virtual network."
  type        = string
}

variable "aks_subnet_cidr" {
  description = "Address prefix for the AKS node subnet inside the VNet."
  type        = string
  default     = "10.52.0.0/20"
}

variable "pod_cidr" {
  description = "Overlay CIDR for pod IPs. Must not overlap the VNet or service CIDR."
  type        = string
  default     = "10.244.0.0/16"
}

variable "service_cidr" {
  description = "CIDR for Kubernetes services. Must not overlap the VNet or pod CIDR."
  type        = string
  default     = "10.53.0.0/16"
}

variable "dns_service_ip" {
  description = "IP address for the cluster DNS service inside the service CIDR."
  type        = string
  default     = "10.53.0.10"
}

variable "node_count" {
  description = "Number of nodes in the AKS system node pool."
  type        = number
  default     = 1
}

variable "node_vm_size" {
  description = "VM size for the AKS system node pool."
  type        = string
  default     = "Standard_D2s_v3"
}

variable "workload_identity_namespace" {
  description = "Kubernetes namespace bound to the workload managed identity."
  type        = string
  default     = "lab-workloads"
}

variable "workload_identity_service_account" {
  description = "Kubernetes service account bound to the workload managed identity."
  type        = string
  default     = "hello-world"
}
