terraform {
  required_version = ">= 1.6.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.100"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
  #   backend "azurerm" {
  #     resource_group_name  = "rg-tfstate"
  #     storage_account_name = "tfstateacct001"
  #     container_name       = "tfstate"
  #     key                  = "coalfire-dev.tfstate"
  #     use_azuread_auth     = true
  #   }
}

provider "azurerm" {
  features {}
}

resource "random_string" "suffix" {
  length  = 5
  upper   = false
  special = false
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

module "network" {
  source              = "../../modules/network"
  name_prefix         = var.name_prefix
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  # address space and subnets
  vnet_cidr = "10.0.0.0/16"
  subnet_cidrs = {
    web        = "10.0.1.0/24"
    app        = "10.0.2.0/24"
    backend    = "10.0.3.0/24"
    management = "10.0.4.0/24"
  }
  mgmt_subnet_cidr = "10.0.4.0/24"

  # access + tags
  allowed_admin_cidr = var.allowed_admin_cidr
  tags               = var.tags
}


module "storage" {
  source              = "../../modules/storage"
  name_prefix         = var.name_prefix
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  suffix              = random_string.suffix.result

  mgmt_subnet_id = module.network.subnet_ids["management"]

  tags = var.tags
}

module "compute" {
  source              = "../../modules/compute"
  name_prefix         = var.name_prefix
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  web_subnet_id  = module.network.subnet_ids["web"]
  mgmt_subnet_id = module.network.subnet_ids["management"]

  admin_username   = var.admin_username
  admin_ssh_pubkey = var.admin_ssh_pubkey
  vm_size          = var.vm_size
  scripts_path     = "${path.module}/../../scripts/install_apache.sh"

  tags = var.tags
}

module "lb" {
  source              = "../../modules/loadbalancer"
  name_prefix         = var.name_prefix
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  backend_nic_ids = module.compute.web_nic_ids
  backend_count   = 2 # ← add this (matches count of web_nic in compute)

  backend_port = 80
  probe_port   = 80
  tags         = var.tags
}
