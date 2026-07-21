# ==================================================
# 1. BASE RÉSEAU ET SOUS-RÉSEAU
# ==================================================

resource "azurerm_virtual_network" "main" {
  name                = "${var.name_prefix}-vnet"
  address_space=["10.40.0.0/16"]
  location            = azurerm_resource_group.lab.location
  resource_group_name = azurerm_resource_group.lab.name
  tags                = local.tags
}
resource "azurerm_subnet" "web"{
    name                 = "${var.name_prefix}-subnet"
    resource_group_name  = azurerm_resource_group.lab.name
    virtual_network_name = azurerm_virtual_network.main.name
    address_prefixes     = ["10.40.1.0/24"]

}

# ==================================================
# 2.5 NETWORK SECURITY GROUP (RD P RESTRICTION)
# ==================================================

resource "azurerm_network_security_group" "rdp" {
  name                = "${var.name_prefix}-nsg"
  location            = azurerm_resource_group.lab.location
  resource_group_name = azurerm_resource_group.lab.name

  security_rule {
    name                       = "allow-rdp-from-admin"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = var.admin_cidr
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "deny-rdp-internet"
    priority                   = 4000
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
  }

  tags = local.tags
}

resource "azurerm_subnet_network_security_group_association" "web" {
  subnet_id                 = azurerm_subnet.web.id
  network_security_group_id = azurerm_network_security_group.rdp.id
}

# ==================================================
# 2. IPS PUBLIQUES MULTIPLES (COUNT)
# ==================================================

resource "azurerm_public_ip" "web" {
  count               = var.instance_count
  name                = "${var.name_prefix}-pip-${count.index + 1}"
  location            = azurerm_resource_group.lab.location
  resource_group_name = azurerm_resource_group.lab.name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = local.tags
}

# ==================================================
# 3. INTERFACES RÉSEAU MULTIPLES (COUNT)
# ==================================================

resource "azurerm_network_interface" "web" {
  count               = var.instance_count
  name                = "${var.name_prefix}-nic-${count.index + 1}"
  location            = azurerm_resource_group.lab.location
  resource_group_name = azurerm_resource_group.lab.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.web.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.web[count.index].id
  }
  tags                = local.tags

  depends_on = [azurerm_public_ip.web]
}

# ==================================================
# 4. MACHINES VIRTUELLES WINDOWS MULTIPLES (COUNT)
# ==================================================

resource "random_password" "windows_admin" {
  length           = 16
  special          = true
  min_special      = 2
  min_lower = 2
  min_numeric = 2
  override_special = "!@#$%&*()-_=+[]{}<>:?"
}

resource "azurerm_windows_virtual_machine" "web" {
  count               = var.instance_count
  name                = "${var.name_prefix}-vm-${count.index + 1}"
  resource_group_name = azurerm_resource_group.lab.name
  location            = azurerm_resource_group.lab.location
  size                = "Standard_D2s_v3"
  admin_username      = var.admin_username
  admin_password      = random_password.windows_admin.result
  network_interface_ids = [
    azurerm_network_interface.web[count.index].id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = 127
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-datacenter-azure-edition"
    version   = "latest"
  }

  tags                = local.tags

  depends_on = [azurerm_network_interface.web]
}