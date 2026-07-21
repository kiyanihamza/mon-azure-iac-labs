variable "environment" {
    description = "Deployment environment"
    type = string
    default= "dev"
    validation {
        condition     = contains(["dev", "staging", "prod"], var.environment)
        error_message = "The environment variable must be one of: dev, staging, prod."
    }

  
}

variable "region" {
    description = "The  region to deploy resources in"
    type = string
    default = "us-east-1"
    validation {
        condition     = contains(["us-east-1", "us-west-2", "eu-west-1"], var.region)
        error_message = "The region variable must be one of: us-east-1, us-west-2, eu-west-1."
    }
}

variable "location" {
    type = string
    default= "eastus"
}

variable "subscription_id" {
  description = "Azure subscription ID. Leave null to use the active Azure CLI subscription when supported."
  type        = string
  default     = null
}

variable "name_prefix" {
    description = "Prefix for resource names"
    type        = string
    default     = "clz"
    validation {
        condition     = can(regex("^[a-z][a-z0-9]{1,7}$", var.name_prefix))
        error_message = "The name_prefix variable must be a string of 2-8 lowercase letters or numbers, starting with a letter."
    }
}

variable "admin_username" {
    description = "Admin username for the virtual machine"
    type        = string
    default     = "clzadmin"
    validation {
        condition     = can(regex("^[a-zA-Z][a-zA-Z0-9]{2,15}$", var.admin_username))
        error_message = "The admin_username variable must be a string of 3-16 alphanumeric characters, starting with a letter."
    }
}

variable "admin_cidr"{
    description = "CIDR block for admin access"
    type        = string
    default     = "0.0.0.0/0"
    validation {
        condition     = can(cidrnetmask(var.admin_cidr))
        error_message = "The admin_cidr variable must be a valid CIDR block."
    }
}

variable "instance_count" {
    description = "Default number of windows instance"
    type = number
    default = 2
}

variable "lab_id" {
    description = "Lab ID for the deployment"
    type        = string
    default     = "CLZ-240"
    
}
