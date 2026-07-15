# ==========================================
# 1. BASE RÉSEAU, SOUS-RÉSEAU APPLICATIF & BASTION
# ==========================================

resource "azurerm_virtual_network" "main" {
  name                = "${local.prefix}-vnet"
  address_space       = ["10.40.0.0/16"]
  location            = azurerm_resource_group.lab.location
  resource_group_name = azurerm_resource_group.lab.name
  tags                = local.tags
}

# Sous-réseau applicatif privé pour la VM
resource "azurerm_subnet" "web" {
  name                 = "web-snet"
  resource_group_name  = azurerm_resource_group.lab.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.40.1.0/24"]
}

# Sous-réseau requis par Azure Bastion (Nom strict et taille minimale /26)
resource "azurerm_subnet" "bastion" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.lab.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.40.20.0/26"]
}

# ==========================================
# 2. CONFIGURATION D'AZURE BASTION
# ==========================================

# IP Publique requise par la passerelle Bastion (Standard & Statique obligatoires)
resource "azurerm_public_ip" "bastion" {
  name                = "${local.prefix}-bas-pip"
  location            = azurerm_resource_group.lab.location
  resource_group_name = azurerm_resource_group.lab.name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = local.tags
}

# L'hôte Azure Bastion

resource "azurerm_bastion_host" "main" {
    name = "${local.prefix}-bastion"
    resource_group_name = azurerm_resource_group.lab.name
    location = azurerm_resource_group.lab.location
    tags = local.tags
    ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.bastion.id
    public_ip_address_id = azurerm_public_ip.bastion.id
  }
}
  
# ==========================================
# 3. CRÉATION DE LA VM WINDOWS ENTIÈREMENT PRIVÉE
# ==========================================

# Mot de passe aléatoire hautement sécurisé
resource "random_password" "windows_admin" {
  length           = 20
  special          = true
  min_upper        = 2
  min_lower        = 2
  min_numeric      = 2
  min_special      = 2
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

# Interface réseau privée (NIC) - SANS ip publique associée
resource "azurerm_network_interface" "private_web" {
  name                = "${local.prefix}-private-web-nic"
  location            = azurerm_resource_group.lab.location
  resource_group_name = azurerm_resource_group.lab.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.web.id
    private_ip_address_allocation = "Dynamic"
  }
  tags = local.tags
}

# VM Windows Server connectée à la NIC privée
resource "azurerm_windows_virtual_machine" "private_web" {
  name                  = "${local.prefix}-private-web-winvm"
  computer_name         = "clz${local.lab_number}"
  location              = azurerm_resource_group.lab.location
  resource_group_name   = azurerm_resource_group.lab.name
  size                  = "Standard_D2s_v3" # N'hésitez pas à la modifier en cas de capacité insuffisante dans votre région
  admin_username        = var.admin_username
  admin_password        = random_password.windows_admin.result
  network_interface_ids = [azurerm_network_interface.private_web.id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-datacenter-azure-edition"
    version   = "latest"
  }

  tags = local.tags
}