# Central telemetry sink for the lab. The AKS Container Insights add-on
# (oms_agent) ships cluster and container logs here.
resource "azurerm_log_analytics_workspace" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = var.retention_in_days
  tags                = var.tags
}
