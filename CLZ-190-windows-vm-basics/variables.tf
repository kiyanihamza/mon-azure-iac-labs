
variable "subscription_id" {
    description ="Azure subscrption ID. leave null to use the active Azure CLI subscription when supported."
    type = string
    default = null
  
}

variable "environment" {
    description = "Deployment environment name"
    type = string
    default = "dev"
    validation {
      condition = contains(["dev","prod","test"], var.environment)
      error_message = "Use dev, test, or prod."
    }
  
}

variable "location" {
    description = "Azure region for this lab."
    type = string
    default = "eastus2"
  
}

variable "lab_id" {
    description = "Azure From Zero to Hero lesson ID."
    type = string
    default = "CLZ-190"
    
  
}

variable "name_prefix" {
    description = "Short Prefix used in Azure resource names."
    type = string
    default = "clz"
  
}

variable "admin_username" {
    description = "Administrator username for the Windows VM."
    type = string
    default = "clzadmin"
  
}

variable "admin_cidr" {
    description = "The IP address range allowed to connect via administrative protocols (RDP)."
    type = string
    default = "0.0.0.0/0"
  
}