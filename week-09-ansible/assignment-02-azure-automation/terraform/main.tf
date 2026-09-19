data "http" "current_ip" {
  url = "https://api.ipify.org"

  request_headers = {
    Accept = "text/plain"
  }
}

locals {
  vm_names = ["web1", "web2", "app1", "db1"]
  vm_roles = ["web", "web", "app", "db"]
}

resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location

  tags = {
    Project    = "Week-09-Ansible"
    Assignment = "Assignment-02"
  }
}

resource "azurerm_virtual_network" "main" {
  name                = "Week-09-Ansible-VNet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  tags = {
    Project = "Week-09-Ansible"
  }
}

resource "azurerm_subnet" "main" {
  name                 = "Week-09-Ansible-Subnet"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_security_group" "main" {
  name                = "Week-09-Ansible-NSG"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  security_rule {
    name                       = "Allow-SSH-Current-IP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "${chomp(data.http.current_ip.response_body)}/32"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-HTTP"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    Project = "Week-09-Ansible"
  }
}

resource "azurerm_subnet_network_security_group_association" "main" {
  subnet_id                 = azurerm_subnet.main.id
  network_security_group_id = azurerm_network_security_group.main.id
}

resource "azurerm_public_ip" "vm" {
  count = length(local.vm_names)

  name                = "${local.vm_names[count.index]}-Public-IP"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = {
    Name = local.vm_names[count.index]
    Role = local.vm_roles[count.index]
  }
}

resource "azurerm_network_interface" "vm" {
  count = length(local.vm_names)

  name                = "${local.vm_names[count.index]}-NIC"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.main.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm[count.index].id
  }

  tags = {
    Name = local.vm_names[count.index]
    Role = local.vm_roles[count.index]
  }
}

resource "azurerm_linux_virtual_machine" "vm" {
  count = length(local.vm_names)

  name                = local.vm_names[count.index]
  computer_name       = local.vm_names[count.index]
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  size                = var.vm_size
  admin_username      = var.admin_username

  disable_password_authentication = true

  network_interface_ids = [
    azurerm_network_interface.vm[count.index].id
  ]

  admin_ssh_key {
    username   = var.admin_username
    public_key = file(pathexpand(var.ssh_public_key_path))
  }

  os_disk {
    name                 = "${local.vm_names[count.index]}-OS-Disk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  tags = {
    Name       = local.vm_names[count.index]
    Role       = local.vm_roles[count.index]
    Assignment = "Week-09-Assignment-02"
  }

  depends_on = [
    azurerm_subnet_network_security_group_association.main
  ]
}