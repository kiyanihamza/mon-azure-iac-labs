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
  default = "CLZ-120"
}

variable "name_prefix" {
  type    = string
  default = "clz"
}

variable "subscription_id" {
  type        = string
  default     = null
  description = "If null, Terraform will use the active Azure CLI subscription context"
}