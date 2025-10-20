
resource "azurerm_virtual_network" "vnet" {
  name                = "${var.name_prefix}-vnet"
  address_space       = [var.vnet_cidr]
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_network_security_group" "nsg" {
  for_each            = var.subnet_cidrs
  name                = "${var.name_prefix}-nsg-${each.key}"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_subnet" "subnet" {
  for_each             = var.subnet_cidrs
  name                 = each.key
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [each.value]
  service_endpoints    = each.key == "management" ? ["Microsoft.Storage"] : []
  depends_on = [azurerm_virtual_network.vnet]
}

resource "azurerm_subnet_network_security_group_association" "assoc" {
  for_each                  = var.subnet_cidrs
  subnet_id                 = azurerm_subnet.subnet[each.key].id
  network_security_group_id = azurerm_network_security_group.nsg[each.key].id
}

# HTTP only from Azure Load Balancer to web subnet
resource "azurerm_network_security_rule" "web_allow_http_from_lb" {
  name                        = "allow_http_from_lb"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "AzureLoadBalancer"
  destination_address_prefix  = azurerm_subnet.subnet["web"].address_prefixes[0]
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.nsg["web"].name
}

# Management subnet NSG: allow SSH from a single admin CIDR only
resource "azurerm_network_security_rule" "mgmt_allow_ssh_from_admin" {
  name                        = "allow_ssh_from_admin"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = var.allowed_admin_cidr
  destination_address_prefix  = azurerm_subnet.subnet["management"].address_prefixes[0]
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.nsg["management"].name
}



# Explicit deny SSH from Internet to web (implicit deny exists, but being explicit for clarity)
resource "azurerm_network_security_rule" "web_deny_ssh_internet" {
  name                        = "deny_ssh_internet"
  priority                    = 4000
  direction                   = "Inbound"
  access                      = "Deny"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "Internet"
  destination_address_prefix  = azurerm_subnet.subnet["web"].address_prefixes[0]
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.nsg["web"].name
}
