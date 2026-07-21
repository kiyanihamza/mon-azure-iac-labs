# ==================================================
# 1. BASE RÉSEAU ET SOUS-RÉSEAU
# ==================================================
resource "azurerm_virtual_network" "main" {
  name                = "${local.prefix}-vnet"
  address_space       = ["10.40.0.0/16"]
  location =    azurerm_resource_group.lab.location
  resource_group_name = azurerm_resource_group.lab.name
  tags                = local.tags  
}

resource "azurerm_subnet" "web" {
  name                 = "${local.prefix}-subnet"
  resource_group_name  = azurerm_resource_group.lab.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.40.1.0/24"]
}
# ==================================================
# 2. NSG
# ==================================================
resource "azurerm_network_security_group" "web" {
  name                = "${local.prefix}-nsg"
  location            = azurerm_resource_group.lab.location
  resource_group_name = azurerm_resource_group.lab.name
  tags                = local.tags
  security_rule{
    name                        = "allow-http"
    priority                    = 100
    direction                   = "Inbound"
    access                      = "Allow"
    protocol                    = "Tcp"
    source_port_range           = "*"
    destination_port_range      = "80"
    source_address_prefix       = "Internet"
    destination_address_prefix  = "*"
    
  }

  security_rule {
    name                        = "allow-admin-rdp"
    priority                    = 110
    direction                   = "Inbound"
    access                      = "Allow"
    protocol                    = "Tcp"
    source_port_range           = "*"
    destination_port_range      = "3389"
    source_address_prefix       = var.admin_cidr
    destination_address_prefix  = "*"
  }
  
  
}


resource "azurerm_subnet_network_security_group_association" "web" {
  subnet_id                 = azurerm_subnet.web.id
  network_security_group_id = azurerm_network_security_group.web.id
}
  

# ==================================================
# 3. IPS PUBLIQUES NOMMÉES (FOR_EACH)
# ==================================================

resource "azurerm_public_ip" "web" {
  for_each            = var.vm_names
  name                = "${local.prefix}-${each.value}-pip"
  location            = azurerm_resource_group.lab.location
  resource_group_name = azurerm_resource_group.lab.name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = local.tags
}

# ==================================================
# 4. INTERFACES RÉSEAU NOMMÉES (FOR_EACH)
# ==================================================

resource "azurerm_network_interface" "web" {
  for_each            = var.vm_names
  name                = "${local.prefix}-${each.value}-nic"
  location            = azurerm_resource_group.lab.location
  resource_group_name = azurerm_resource_group.lab.name

  ip_configuration {
    name                          = "${local.prefix}-${each.value}-ipconfig"
    subnet_id                     = azurerm_subnet.web.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.web[each.key].id
  }

  tags = local.tags

  depends_on = [azurerm_subnet.web]
}

# ==================================================
# 4. MACHINES VIRTUELLES WINDOWS NOMMÉES (FOR_EACH)
# ==================================================
resource "random_password" "vm_admin" {
  for_each = var.vm_names
  length           = 16
  special          = true
  override_special = "!@#$%&*()-_=+[]{}<>:?"
}

resource "azurerm_windows_virtual_machine" "web" {
  for_each            = var.vm_names
  name                = "${local.prefix}-${each.key}-winvm"
  resource_group_name = azurerm_resource_group.lab.name
  location            = azurerm_resource_group.lab.location
  size                = "Standard_D2s_v3"
  admin_username      = var.admin_username
  admin_password      = random_password.vm_admin[each.key].result
  computer_name       = substr("${replace(local.prefix, "-", "")}${each.key}", 0, 15)
  network_interface_ids = [
    azurerm_network_interface.web[each.key].id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = 127
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }

  tags = local.tags

  depends_on = [azurerm_network_interface.web]
}
