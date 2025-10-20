output "subnet_ids" {
  description = "Map of subnet name => subnet ID"
  value       = { for k, s in azurerm_subnet.subnet : k => s.id }
}

output "nsg_ids" {
  description = "Map of subnet name => NSG ID"
  value       = { for k, n in azurerm_network_security_group.nsg : k => n.id }
}
