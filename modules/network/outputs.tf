output "id" { value = azurerm_virtual_network.this.id }
output "name" { value = azurerm_virtual_network.this.name }
output "aks_subnet_id" { value = azurerm_subnet.aks.id }
