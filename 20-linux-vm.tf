# Create public IPs
resource "azurerm_public_ip" "myterraformpublicip" {
    name                         = "LinuxPublicIP"
    location            = "${azurerm_resource_group.network.location}"
    resource_group_name = "${azurerm_resource_group.network.name}"
    public_ip_address_allocation = "dynamic"

    tags {
        environment = "Terraform CG Demo"
    }
}

# Create Network Security Group and rule
resource "azurerm_network_security_group" "myterraformnsg" {
    name                = "LinuxNetworkSecurityGroup"
    location            = "${azurerm_resource_group.network.location}"
    resource_group_name = "${azurerm_resource_group.network.name}"

    security_rule {
        name                       = "SSH"
        priority                   = 1001
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }

    tags {
        environment = "Terraform CG Demo"
    }
}

# Create network interface
resource "azurerm_network_interface" "myterraformnic" {
    name                      = "myNIC"
    location            = "${azurerm_resource_group.network.location}"
    resource_group_name = "${azurerm_resource_group.network.name}"
    network_security_group_id = "${azurerm_network_security_group.myterraformnsg.id}"

    ip_configuration {
        name                          = "MyNicConfiguration"
        subnet_id                     = "${azurerm_subnet.snet_web.id}"
        private_ip_address_allocation = "dynamic"
        public_ip_address_id          = "${azurerm_public_ip.myterraformpublicip.id}"
    }

    tags {
        environment = "Terraform CG Demo"
    }
}

# Generate random text for a unique storage account name
resource "random_id" "randomId" {
    keepers = {
        # Generate a new ID only when a new resource group is defined
        resource_group = "${azurerm_resource_group.network.name}"
    }

    byte_length = 8
}

# Create storage account for boot diagnostics
resource "azurerm_storage_account" "mystorageaccount" {
    name                        = "diag${random_id.randomId.hex}"
    resource_group_name         = "${azurerm_resource_group.network.name}"
    location            = "${azurerm_resource_group.network.location}"
    account_tier                = "Standard"
    account_replication_type    = "LRS"

    tags {
        environment = "Terraform CG Demo"
    }
}

# Create virtual machine
resource "azurerm_virtual_machine" "myterraformvm" {
    name                  = "myVM"
    location            = "${azurerm_resource_group.network.location}"
    resource_group_name   = "${azurerm_resource_group.network.name}"
    network_interface_ids = ["${azurerm_network_interface.myterraformnic.id}"]
    vm_size               = "Standard_DS1_v2"
    # Uncomment this line to delete the OS disk automatically when deleting the VM
    delete_os_disk_on_termination = true
    # Uncomment this line to delete the data disks automatically when deleting the VM
    delete_data_disks_on_termination = true

    storage_os_disk {
        name              = "myOsDisk"
        caching           = "ReadWrite"
        create_option     = "FromImage"
        managed_disk_type = "Standard_LRS"
    }

    storage_image_reference {
        publisher = "Canonical"
        offer     = "UbuntuServer"
        sku       = "16.04.0-LTS"
        version   = "latest"
    }

    os_profile {
        computer_name  = "myvm"
        admin_username = "azureuser"
    }

    os_profile_linux_config {
        disable_password_authentication = true
        ssh_keys {
            path     = "/home/azureuser/.ssh/authorized_keys"
            key_data = "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAIEA3NmZ5u+rKPYWhOsmXWyzmDJfREW3tDHV/R9l3gLzzArkpno5NNvRQuVEyNtAvcqt2CbRytrbpE1eF5fbAwamEHgO/fmZRdfrzxx//k/EiUzpes+brlQnpaZdpAhEx16Xh9t/Pq0Ui6FrqKlrj5ZLwX1qgpYr0ZQaAnyCwrsAbNM="
        }
    }

    boot_diagnostics {
        enabled = "true"
        storage_uri = "${azurerm_storage_account.mystorageaccount.primary_blob_endpoint}"
    }

    tags {
        environment = "Terraform CG Demo"
    }
}
