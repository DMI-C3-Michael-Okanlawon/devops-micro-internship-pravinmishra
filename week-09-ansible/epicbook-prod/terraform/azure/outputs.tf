output "public_ip" {
  description = "Public IP address of the EpicBook VM"
  value       = azurerm_public_ip.web.ip_address
}

output "admin_user" {
  description = "Administrator username for SSH access"
  value       = azurerm_linux_virtual_machine.web.admin_username
}

output "ssh_command" {
  description = "Command for connecting to the EpicBook VM"
  value       = "ssh -i ~/.ssh/id_ed25519 ${azurerm_linux_virtual_machine.web.admin_username}@${azurerm_public_ip.web.ip_address}"
}