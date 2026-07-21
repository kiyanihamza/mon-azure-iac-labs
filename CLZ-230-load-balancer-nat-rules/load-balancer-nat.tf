# ==================================================
# 1. BASE RÉSEAU ET SOUS-RÉSEAU
# ==================================================

resource "azurerm_virtual_network" "main" {
  name                = "${local.prefix}-vnet"
  address_space       = ["10.40.0.0/16"]
  location            = azurerm_resource_group.lab.location
  resource_group_name = azurerm_resource_group.lab.name
  tags                = local.tags
}

resource "azurerm_subnet" "web" {
  name                 = "web-snet"
  resource_group_name  = azurerm_resource_group.lab.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.40.1.0/24"]
}

# ==================================================
# 2. SÉCURITÉ RÉSEAU (NSG)
# ==================================================

resource "azurerm_network_security_group" "web" {
  name                = "${local.prefix}-web-nsg"
  location            = azurerm_resource_group.lab.location
  resource_group_name = azurerm_resource_group.lab.name
  tags                = local.tags
}

resource "azurerm_network_security_rule" "allow_http" {
  name                        = "allow-http"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "Internet"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.lab.name
  network_security_group_name = azurerm_network_security_group.web.name
}

resource "azurerm_network_security_rule" "allow_admin_rdp" {
  name                        = "allow-admin-rdp"
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "3389" # Le NSG filtre sur le port final de destination de la VM
  source_address_prefix       = var.admin_cidr
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.lab.name
  network_security_group_name = azurerm_network_security_group.web.name
}

resource "azurerm_subnet_network_security_group_association" "web" {
  subnet_id                 = azurerm_subnet.web.id
  network_security_group_id = azurerm_network_security_group.web.id

  # Assure que le subnet est complètement prêt avant l'association
  depends_on = [azurerm_subnet.web]
}

# ==================================================
# 3. LE LOAD BALANCER & RÈGLES DE ROUTAGE
# ==================================================

resource "azurerm_public_ip" "lb" {
    name = "${local.prefix}-lb-pip"
    location = azurerm_resource_group.lab.location
    resource_group_name = azurerm_resource_group.lab.name
    allocation_method = "Static"
    sku = "Standard"
    tags = local.tags
  
}

resource "azurerm_lb" "web" {
    name ="${local.prefix}-web-lb"
    location = azurerm_resource_group.lab.location
    resource_group_name = azurerm_resource_group.lab.name
    sku = "Standard"
    tags = local.tags
    frontend_ip_configuration {
      name = "public"
      public_ip_address_id = azurerm_public_ip.lb.id
    }
  
}

resource "azurerm_lb_backend_address_pool" "web" {
    name = "web-backend-pool"
    loadbalancer_id = azurerm_lb.web.id
  
}

resource "azurerm_lb_probe" "http" {
    name = "http-probe"
    loadbalancer_id = azurerm_lb.web.id
    protocol = "Tcp"
    port = 80
  
}

# Règle HTTP classique pour équilibrer le trafic Web
resource "azurerm_lb_rule" "name" {
    name = "http-rule"
    loadbalancer_id = azurerm_lb.web.id
    protocol = "Tcp"
    frontend_port = 80
    backend_port = 80
    frontend_ip_configuration_name = "public"
    backend_address_pool_ids = [azurerm_lb_backend_address_pool.web.id]
    probe_id = azurerm_lb_probe.http.id
  
}

# NOUVEAU : Règle de redirection NAT pour le RDP


resource "azurerm_lb_nat_rule" "rdp_first" {
  name                           = "rdp-first-backend"
  resource_group_name            = azurerm_resource_group.lab.name
  loadbalancer_id                = azurerm_lb.web.id
  protocol                       = "Tcp"
  frontend_port                  = 50001 # Port exposé sur Internet
  backend_port                   = 3389  # Port d'écoute réel RDP sur la VM Windows
  frontend_ip_configuration_name = "public"
}

# ==================================================
# 4. CARTES RÉSEAUX ET ASSOCIATIONS (NICs)
# ==================================================

resource "azurerm_network_interface" "web" {
  count               = var.instance_count
  name                = "${local.prefix}-web-${count.index + 1}-nic"
  location            = azurerm_resource_group.lab.location
  resource_group_name = azurerm_resource_group.lab.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.web.id
    private_ip_address_allocation = "Dynamic"
  }
  tags = local.tags

  depends_on = [azurerm_subnet.web]
}

# Association globale des NICs au pool d'arrière-plan du LB
resource "azurerm_network_interface_backend_address_pool_association" "web" {
  count                   = var.instance_count
  network_interface_id    = azurerm_network_interface.web[count.index].id
  ip_configuration_name   = "internal"
  backend_address_pool_id = azurerm_lb_backend_address_pool.web.id
}

# NOUVEAU : Association exclusive de la règle NAT à la VM 1 uniquement
resource "azurerm_network_interface_nat_rule_association" "rdp_first" {
  network_interface_id  = azurerm_network_interface.web[0].id # Première VM
  ip_configuration_name = "internal"
  nat_rule_id           = azurerm_lb_nat_rule.rdp_first.id
}

# ==================================================
# 5. LES DEUX MACHINES VIRTUELLES WINDOWS
# ==================================================

resource "random_password" "windows_admin" {
  length           = 20
  special          = true
  min_upper        = 2
  min_lower        = 2
  min_numeric      = 2
  min_special      = 2
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "azurerm_windows_virtual_machine" "web" {
  count                 = var.instance_count
  name                  = "${local.prefix}-web-${count.index + 1}-winvm"
  computer_name         = "clz${local.lab_number}${count.index + 1}"
  location              = azurerm_resource_group.lab.location
  resource_group_name   = azurerm_resource_group.lab.name
  size                  = "Standard_D2s_v3" # <-- Changé en B2s (ou D2s_v3) pour passer vos quotas
  admin_username        = var.admin_username
  admin_password        = random_password.windows_admin.result
  network_interface_ids = [azurerm_network_interface.web[count.index].id]

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

# Installation silencieuse de IIS
resource "azurerm_virtual_machine_extension" "iis" {
  count                      = var.instance_count
  name                       = "install-iis"
  virtual_machine_id         = azurerm_windows_virtual_machine.web[count.index].id
  publisher                  = "Microsoft.Compute"
  type                       = "CustomScriptExtension"
  type_handler_version       = "1.10"
  auto_upgrade_minor_version = true

  settings = jsonencode({
    commandToExecute = "powershell -ExecutionPolicy Unrestricted -Command \"Install-WindowsFeature -Name Web-Server -IncludeManagementTools; Set-Content -Path C:\\inetpub\\wwwroot\\index.html -Value 'Azure From Zero To Hero backend ${count.index + 1}'\""
  })
}