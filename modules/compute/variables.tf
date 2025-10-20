variable "name_prefix" { type = string }
variable "location" { type = string }
variable "resource_group_name" { type = string }

variable "web_subnet_id" { type = string }
variable "mgmt_subnet_id" { type = string }

variable "admin_username" { type = string }
variable "admin_ssh_pubkey" { type = string }
variable "vm_size" { type = string }

variable "scripts_path" { type = string }
variable "tags" { type = map(string) }
