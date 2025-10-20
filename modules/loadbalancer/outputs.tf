output "public_ip" {
  description = "Public IP address of the load balancer"
  value       = azurerm_public_ip.lb_pip.ip_address
}
