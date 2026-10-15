# AWS conceptual equivalent: VPC with a private subnet for worker nodes
# Azure implementation: Virtual Network with an AKS subnet
resource "azurerm_virtual_network" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = [var.vnet_cidr]
  tags                = var.tags
}

# The AKS node pool attaches to this subnet. Pods use the overlay pod CIDR,
# so the subnet only needs addresses for nodes and cluster services.
resource "azurerm_subnet" "aks" {
  name                 = "snet-aks"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = [var.aks_subnet_cidr]

  service_endpoint {
    service = "Microsoft.ContainerRegistry"
  }
}
