variable "subscription_id" {
  description = "Azure subscription ID. Leave null to use the active Azure CLI subscription when supported."
  type        = string
  default     = null
}

variable "environment" {
  description = "Deployment environment name."
  type        = string
  default     = "dev"
  validation {
    condition     = contains(["dev", "test", "prod"], var.environment)
    error_message = "Use dev, test, or prod."
  }
}

variable "location" {
  description = "Azure region for this lab."
  type        = string
  default     = "eastus"
}

variable "lab_id" {
  description = "Azure From Zero To Hero lesson ID."
  type        = string
  default     = "CLZ-220"
}

variable "name_prefix" {
  description = "Short prefix used in Azure resource names."
  type        = string
  default     = "clz"
}

variable "admin_username" {
  description = "Administrator username for the Windows VMs."
  type        = string
  default     = "clzadmin"
}

variable "admin_cidr" {
  description = "The IP address range allowed to connect via administrative protocols."
  type        = string
  default     = "203.0.113.10/32"
}

variable "instance_count" {
  description = "Number of VM instances."
  type        = number
  default     = 2
}