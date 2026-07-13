variable "environment" {
  type    = string
  default = "dev"
}

variable "location" {
  type    = string
  default = "eastus2"
}

variable "lab_id" {
  type    = string
  default = "CLZ-130"
}

variable "name_prefix" {
  type    = string
  default = "clz"
}

variable "subscription_id" {
  description = "Azure subscription ID. Leave null to use the active Azure CLI subscription when supported."
  type        = string
  default     = null
}