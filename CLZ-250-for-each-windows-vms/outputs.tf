output "resource_group_name" {
  description = "Resource group created by this lab."
  value       = azurerm_resource_group.lab.name
}

output "windows_vm_public_ips" {
  description = "Public IPs created with for_each."
  value       = { for name, pip in azurerm_public_ip.web : name => pip.ip_address }
}

output "windows_admin_password" {
  description = "Generated Windows admin password."
  value       = { for name, pw in random_password.vm_admin : name => pw.result }
  sensitive   = true
}
