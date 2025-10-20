variable "name_prefix" { type = string }
variable "location" { type = string }
variable "resource_group_name" { type = string }
variable "vnet_cidr" { type = string }
variable "subnet_cidrs" { type = map(string) }
variable "mgmt_subnet_cidr" { type = string }
variable "allowed_admin_cidr" { type = string }
variable "tags" { type = map(string) }
