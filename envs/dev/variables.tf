# Root variables for envs/dev

variable "resource_group_name" {
  type        = string
  description = "Name of the Azure resource group to create/use."
}

variable "location" {
  type        = string
  description = "Azure region (e.g., eastus)."
}

variable "name_prefix" {
  type        = string
  description = "Prefix used when naming Azure resources."
}

variable "admin_username" {
  type        = string
  description = "Admin username for Linux VMs."
}

variable "admin_ssh_pubkey" {
  type        = string
  description = "SSH public key to provision on Linux VMs (contents of your *.pub file)."
  sensitive   = true
}

variable "vm_size" {
  type        = string
  description = "VM size for Linux VMs (e.g., Standard_B2s)."
}

variable "allowed_admin_cidr" {
  type        = string
  description = "CIDR that is allowed to SSH to the management VM (e.g., 203.0.113.10/32)."
}

variable "tags" {
  type        = map(string)
  description = "Tags applied to all resources."
}
