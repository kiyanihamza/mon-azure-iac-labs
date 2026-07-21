resource "azurerm_resource_group" "lab" {
  name     = "${var.name_prefix}-rg"
  location = var.location
  tags=local.tags
  
}