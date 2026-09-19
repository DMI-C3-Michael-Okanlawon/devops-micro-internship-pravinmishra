variable "subscription_id" {
  description = "Azure subscription ID"
  type        = string
}

variable "location" {
  description = "Azure region where resources will be deployed"
  type        = string
  default     = "East US"
}

variable "resource_group_name" {
  description = "Name of the Azure resource group"
  type        = string
  default     = "Week-09-Ansible-RG"
}

variable "vm_size" {
  description = "Size used by all four Azure VMs"
  type        = string
  default     = "Standard_B1s"
}

variable "admin_username" {
  description = "Administrator username for all VMs"
  type        = string
  default     = "azureuser"
}

variable "ssh_public_key_path" {
  description = "Local path to the SSH public key"
  type        = string
  default     = "~/.ssh/id_ed25519.pub"
}