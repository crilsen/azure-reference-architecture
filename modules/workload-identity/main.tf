# AWS conceptual equivalent: IAM role for service accounts (IRSA)
# Azure implementation: user-assigned managed identity with a federated identity credential
resource "azurerm_user_assigned_identity" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

# Binds the identity to a Kubernetes service account. The subject must match
# the namespace and service account name used by the workload.
resource "azurerm_federated_identity_credential" "this" {
  name                      = "${var.name}-fic"
  user_assigned_identity_id = azurerm_user_assigned_identity.this.id
  audience                  = ["api://AzureADTokenExchange"]
  issuer                    = var.oidc_issuer_url
  subject                   = "system:serviceaccount:${var.namespace}:${var.service_account_name}"
}
