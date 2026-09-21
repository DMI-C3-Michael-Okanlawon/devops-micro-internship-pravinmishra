output "public_ip" {
  description = "Public IP address of the Mini Finance VM"
  value       = azurerm_public_ip.main.ip_address
}

output "ssh_command" {
  description = "Command for connecting to the VM"
  value       = "ssh -i ~/.ssh/id_ed25519 ${var.admin_username}@${azurerm_public_ip.main.ip_address}"
}

output "ssh_allowed_ip" {
  description = "Public IP allowed to connect through SSH"
  value       = local.ssh_allowed_cidr
}

output "website_url" {
  description = "Public URL of the Mini Finance website"
  value       = "http://${azurerm_public_ip.main.ip_address}"
}