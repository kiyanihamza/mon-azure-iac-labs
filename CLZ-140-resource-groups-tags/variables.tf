variable "environment" {
  description = "Deployment environment name."
  type        = string
  default     = "dev"

  # Règle de gouvernance stricte pour éviter les fautes de frappe ("deev", "prood")
  validation {
    condition     = contains(["dev", "test", "prod"], var.environment)
    error_message = "Use dev, test, or prod."
  }
}

variable "location" {
  description = "Azure region for this lab."
  type        = string
  default     = "eastus2"
}

variable "lab_id" {
  description = "Azure From Zero To Hero lesson ID."
  type        = string
  default     = "CLZ-140"
}

variable "name_prefix" {
  description = "Short prefix used in Azure resource names."
  type        = string
  default     = "clz"
}

variable "subscription_id" {
  type    = string
  default = null
}