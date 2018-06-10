# Configure the Azure Provider
provider "azurerm" { }

# Create a resource group
resource "azurerm_resource_group" "network" {
  name     = "${var.resource_group}"
  location = "${var.dc_location}"
}

# Create a virtual network within the resource group
resource "azurerm_virtual_network" "network" {
  name                = "demo-network"
  address_space       = ["${var.vnet_cidr}"]
  location            = "${azurerm_resource_group.network.location}"
  resource_group_name = "${azurerm_resource_group.network.name}"
  tags {
        environment = "Terraform CG Demo"
    }
}

# Create subnets network within the resource group
resource "azurerm_subnet" "snet_frontend" {
  name                 = "frontend"
  resource_group_name  = "${azurerm_resource_group.network.name}"
  virtual_network_name = "${azurerm_virtual_network.network.name}"
  address_prefix       = "${var.external1_subnet_cidr}"
}

resource "azurerm_subnet" "snet_backend" {
  name                 = "backend"
  resource_group_name  = "${azurerm_resource_group.network.name}"
  virtual_network_name = "${azurerm_virtual_network.network.name}"
  address_prefix       = "${var.internal1_subnet_cidr}"
}

resource "azurerm_subnet" "snet_web" {
  name                 = "web"
  resource_group_name  = "${azurerm_resource_group.network.name}"
  virtual_network_name = "${azurerm_virtual_network.network.name}"
  address_prefix       = "${var.webserver1_subnet_cidr}"
}

resource "azurerm_subnet" "snet_app" {
  name                 = "app"
  resource_group_name  = "${azurerm_resource_group.network.name}"
  virtual_network_name = "${azurerm_virtual_network.network.name}"
  address_prefix       = "${var.app1_subnet_cidr}"
}
