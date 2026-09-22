variable "location" {
  description = "Azure region for the EpicBook resources"
  type        = string
  default     = "eastus"
}

variable "resource_group_name" {
  description = "Name of the Azure resource group"
  type        = string
  default     = "Week-09-EpicBook-Prod-RG"
}

variable "admin_user" {
  description = "Administrator username for the virtual machine"
  type        = string
  default     = "azureuser"
}

variable "ssh_allowed_cidr" {
  description = "Public IP address allowed to connect through SSH"
  type        = string

  validation {
    condition     = can(cidrnetmask(var.ssh_allowed_cidr))
    error_message = "ssh_allowed_cidr must be a valid CIDR, such as 154.113.217.178/32."
  }
}

variable "ssh_public_key_path" {
  description = "Path to the SSH public key used by the VM"
  type        = string
  default     = "id_ed25519.pub"
}