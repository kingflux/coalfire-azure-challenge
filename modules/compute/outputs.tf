output "web_nic_ids" {
  description = "NIC IDs for web VMs (backend pool members)"
  value       = try(
    values(azurerm_network_interface.web_nic)[*].id,  # for_each
    azurerm_network_interface.web_nic[*].id           # count
  )
}

output "mgmt_public_ip" {
  description = "Public IP of management VM"
  value       = azurerm_public_ip.mgmt_pip.ip_address
}
