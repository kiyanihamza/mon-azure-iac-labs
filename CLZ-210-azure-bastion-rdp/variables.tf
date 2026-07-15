variable "subscription_id" {
    description = "Azure subscrption ID. leave null to use the active Azure CLI subscription when supported."
    type = string
    default = null
  
}

variable "lab_id" {
    description = "Azure From Zero to Hero lesson ID."
    type = string
    default = "CLZ-210"
}

variable "name_prefix" {
    description = "Short Prefix used in Azure resource names."
    type = string
    default = "clz"
}

variable "environment" {
    description = "Azure region for this lab."
    type = string
    default = "dev"
    validation {
      condition = contains(["dev","test","prod"],var.environment)
      error_message = "Use dev, prod, or test."
    }
  
}

variable "location" {
  description = "value"
  type = string
  default = "eastus2"
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
variable "instance_count" {
  description = "Number of VM instances."
  type        = number
  default     = 2
}