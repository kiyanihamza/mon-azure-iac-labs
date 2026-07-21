variable "subscription_id" {
    description = "The IP address range allowed to connect via administrative protocols."
    type = string
    default = null
  
}

variable "location" {
    description = "The region of the resource groupe"
    type = string
    default = "eastus"
    
}

variable "environment" {
    description = "Deployment environment name."
    type = string
    default = "dev"

    validation {
      condition = contains(["dev","test","prod"],var.environment)
      error_message = "Use dev, test , or prod ."
    }


  
}
variable "name_prefix" {
    description = "Short prefix used in Azure resources names ."
    type = string
    default = "clz"
  
}

variable "lab_id" {
    description = "Azure from Zero To Hero lesson ID."
    type = string
    default = "CLZ-230"
  
}
variable "admin_cidr" {
    description = "The IP address range allowed to connect via administrative protocols."
    type = string
    default = "0.0.0.0/0"
  
}

variable "admin_username" {
    description = "Administrator username for the Windows VMs."
    type = string
    default = "clzadmin"
  
}
variable "instance_count" {
    description = "Number of VM instances."
    type = number
    default = 2
  
}
