resource "azurerm_network_interface" "demo-vm-001-nic" {
  name                = "demo-vm-001-nic"
  resource_group_name = var.resource_group
  location            = var.location

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet-apps.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "demo-vm-001" {
  name                = "demo-vm-001"
  resource_group_name = var.resource_group
  location            = var.location
  size                = "Standard_DS1_v2"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.demo-vm-001-nic.id,
  ]

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/.ssh/azure.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}

resource "azurerm_virtual_machine_extension" "docker-extension" {
  name                       = "docker-extension"
  virtual_machine_id         = azurerm_linux_virtual_machine.demo-vm-001.id
  publisher                  = "Microsoft.Azure.Extensions"
  type                       = "DockerExtension"
  type_handler_version       = "1.0"
  auto_upgrade_minor_version = true
}
