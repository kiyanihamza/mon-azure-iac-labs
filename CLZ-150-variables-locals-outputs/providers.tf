provider "azurerm" {
  features {}
  subscription_id = var.subscription_id != null ? var.subscription_id : null
}