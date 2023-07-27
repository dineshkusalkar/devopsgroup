provider "azurerm" {
  features {}
    client_id       = "e07a0559-302b-4654-9640-9145e07e147f"
  client_secret   = "AV58Q~XHcqemh5k.E9cNSFojhM3PX5M1qALYwcJm"
  tenant_id       = "483664c7-2998-4342-8915-dcd611c2fefe"
  subscription_id = "7c2ed10b-da64-4ca3-8747-92f46fa59d9a"
  
}

resource "azurerm_resource_group" "linuxvm" {
    name = "dineshvm"
    location = "eastus"
  
}



resource "azurerm_virtual_network" "terra-Vnet" {
  name                = "dineshVnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.linuxvm.location
  resource_group_name = azurerm_resource_group.linuxvm.name
}

resource "azurerm_subnet" "terra-subnet" {
  name                 = "dineshsubnet"
  resource_group_name  = azurerm_resource_group.linuxvm.name
  virtual_network_name = azurerm_virtual_network.terra-Vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_public_ip" "terra-publicip" {
  name                = "dineshpip"                          ##########
  resource_group_name = azurerm_resource_group.linuxvm.name
  location            = azurerm_resource_group.linuxvm.location
  allocation_method   = "Static"

  
}

resource "azurerm_network_interface" "terra-nic" {
  name                = "dineshnic"
  location            = azurerm_resource_group.linuxvm.location
  resource_group_name = azurerm_resource_group.linuxvm.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.terra-subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.terra-publicip.id   ###########
  }
}

resource "azurerm_linux_virtual_machine" "terra-vm" {
  name                = "dineshvm"
  resource_group_name = azurerm_resource_group.linuxvm.name
  location            = azurerm_resource_group.linuxvm.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  admin_password = "Dinesh18@"      #########
  disable_password_authentication = false   #######
  network_interface_ids = [
    azurerm_network_interface.terra-nic.id,
  ]


  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }
}