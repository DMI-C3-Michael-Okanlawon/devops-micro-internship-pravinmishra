output "public_ips" {
  description = "Public IP addresses of all four Azure VMs"

  value = {
    for index, name in local.vm_names :
    name => azurerm_public_ip.vm[index].ip_address
  }
}

output "ssh_allowed_ip" {
  description = "Current public IP permitted through the SSH rule"
  value       = "${chomp(data.http.current_ip.response_body)}/32"
}