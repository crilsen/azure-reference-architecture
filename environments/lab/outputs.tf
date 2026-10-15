output "resource_group_name" {
  value = azurerm_resource_group.lab.name
}

output "cluster_name" {
  value = module.aks.name
}

output "aks_node_resource_group" {
  value = module.aks.node_resource_group
}

output "aks_oidc_issuer_url" {
  value = module.aks.oidc_issuer_url
}

output "acr_login_server" {
  value = module.acr.login_server
}

output "lb_public_ip" {
  value = azurerm_public_ip.lb.ip_address
}

output "lb_resource_group" {
  value = azurerm_resource_group.lab.name
}

output "workload_identity_client_id" {
  value = module.workload_identity.client_id
}

output "get_credentials_command" {
  value = "az aks get-credentials --resource-group ${azurerm_resource_group.lab.name} --name ${module.aks.name}"
}
