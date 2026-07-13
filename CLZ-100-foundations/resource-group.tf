# TODO: Déclarer un groupe de ressources Azure nommé "lab"
# - Le nom (name) doit utiliser le format suivant : "${local.prefix}-rg"
# - La région (location) doit appeler la variable correspondante
# - Les tags doivent appeler le bloc local.tags

resource "azurerm_resource_group" "lab" {
  name     = "${local.prefix}-rg"
  location = var.location
  tags     = local.tags
}