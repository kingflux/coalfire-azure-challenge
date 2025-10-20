variable "name_prefix" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "backend_nic_ids" {
  type        = list(string)
  description = "List of NIC IDs for backend VMs."
}

variable "backend_count" {
  type        = number
  description = "Number of backend NICs to associate with the LB."
}

variable "backend_port" {
  type = number
}

variable "probe_port" {
  type = number
}

variable "tags" {
  type = map(string)
}
