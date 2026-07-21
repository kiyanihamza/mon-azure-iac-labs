variable "subscription_id" {
    description = "The Azure subscription ID"
    type = string
    default = null
}

variable "environment" {
    description = "The environment name (e.g., dev, prod)"
    type = string
    default = "dev"
    validation {
        condition     = contains(["dev", "prod", "staging"], var.environment)
        error_message = "Environment must be one of: dev, prod, staging."
    }
}

variable "location" {
    description = "The Azure region where resources will be deployed"
    type = string
    default = "eastus"
}

variable "name_prefix" {
    description = "The name of the lab"
    type = string
    default = "clz"
}

variable "admin_username" {
    description = "The admin username for the virtual machine"
    type = string
    default = "clzadmin"
}

variable "admin_cidr"{
    description = "The CIDR block for the admin access"
    type = string
    default = "0.0.0.0/0"
}

variable "lab_id" {
    description = "The ID of the lab"
    type = string
    default = "CLZ-250"
}

variable "vm_names" {

    type=map(string)
    default = {
        web = "web"
        ops = "ops"
    }
}