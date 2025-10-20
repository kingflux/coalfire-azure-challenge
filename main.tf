terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

module "network" {
  source             = "./modules/network"
  rg_name            = var.rg_name
  location           = var.location
  vnet_address_space = ["10.0.0.0/16"]
  subnet_prefix      = ["10.0.1.0/24"]
}
