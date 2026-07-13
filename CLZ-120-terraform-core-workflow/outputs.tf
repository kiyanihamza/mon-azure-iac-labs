output "resource_group_name" {
  description = "Resource group created by this lab."
  # TODO: Pointer vers le nom du groupe de ressources créé
  value       = azurerm_resource_group.lab.name
}

output "location" {
  description = "Azure region used by this lab."
  # TODO: Pointer vers la région du groupe de ressources créé
  value       = azurerm_resource_group.lab.location
}