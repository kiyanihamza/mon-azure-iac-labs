# TODO: Déclarer la ressource Azure Resource Group nommée "lab"
# - name doit utiliser la valeur: "${local.prefix}-rg"
# - location doit utiliser var.location
# - tags doit utiliser local.tags

resource "azurerm_resource_group" "lab" {
  # Écrivez votre code ici (ou laissez vide pour l'exercice de l'apprenant)
  name ="${local.prefix}-rg"
  location = var.location
  tags = local.tags
}