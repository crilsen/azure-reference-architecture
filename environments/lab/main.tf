provider "azurerm" {
  features {}
  tenant_id       = var.tenant_id
  subscription_id = var.subscription_id
}

locals {
  tags = {
    project = var.project_name
  }
}

resource "azurerm_resource_group" "lab" {
  name     = "rg-${var.project_name}"
  location = var.azure_location
  tags     = local.tags
}

# ACR names must be globally unique and alphanumeric only.
resource "random_string" "acr_suffix" {
  length  = 6
  special = false
  upper   = false
}

module "network" {
  source              = "../../modules/network"
  name                = "vnet-${var.project_name}"
  location            = azurerm_resource_group.lab.location
  resource_group_name = azurerm_resource_group.lab.name
  vnet_cidr           = var.vnet_cidr
  aks_subnet_cidr     = var.aks_subnet_cidr
  tags                = local.tags
}

module "monitor" {
  source              = "../../modules/monitor"
  name                = "log-${var.project_name}"
  location            = azurerm_resource_group.lab.location
  resource_group_name = azurerm_resource_group.lab.name
  tags                = local.tags
}

module "acr" {
  source              = "../../modules/acr"
  name                = "acr${replace(var.project_name, "-", "")}${random_string.acr_suffix.result}"
  location            = azurerm_resource_group.lab.location
  resource_group_name = azurerm_resource_group.lab.name
  tags                = local.tags
}

module "aks" {
  source                     = "../../modules/aks"
  name                       = "aks-${var.project_name}"
  location                   = azurerm_resource_group.lab.location
  resource_group_name        = azurerm_resource_group.lab.name
  kubernetes_version         = var.kubernetes_version
  dns_prefix                 = var.project_name
  node_count                 = var.node_count
  node_vm_size               = var.node_vm_size
  vnet_subnet_id             = module.network.aks_subnet_id
  pod_cidr                   = var.pod_cidr
  service_cidr               = var.service_cidr
  dns_service_ip             = var.dns_service_ip
  log_analytics_workspace_id = module.monitor.id
  tenant_id                  = var.tenant_id
  acr_id                     = module.acr.id
  tags                       = local.tags
}

module "workload_identity" {
  source               = "../../modules/workload-identity"
  name                 = "id-${var.project_name}"
  location             = azurerm_resource_group.lab.location
  resource_group_name  = azurerm_resource_group.lab.name
  oidc_issuer_url      = module.aks.oidc_issuer_url
  namespace            = var.workload_identity_namespace
  service_account_name = var.workload_identity_service_account
  tags                 = local.tags
}

# Static public IP reserved for the Kubernetes Service of type LoadBalancer.
resource "azurerm_public_ip" "lb" {
  name                = "pip-${var.project_name}"
  location            = azurerm_resource_group.lab.location
  resource_group_name = azurerm_resource_group.lab.name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = local.tags
}

# The AKS cluster identity needs rights on this resource group to attach the
# static public IP to the load balancer it manages.
resource "azurerm_role_assignment" "aks_lb_network_contributor" {
  scope                = azurerm_resource_group.lab.id
  role_definition_name = "Network Contributor"
  principal_id         = module.aks.cluster_identity_principal_id
}
