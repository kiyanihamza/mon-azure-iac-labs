variable "environment" {
    type = string
    default = "dev"
  
}

variable "location" {
  type = string
  default = "eastus2"
}
variable "lab_id" {
    type = string
    default = "CLZ-110"
  
}

variable "subscription_id" {
    type = string
    default = null
    description = "if null ,erraform utilisera l'abonnement actif d'Azure CLI"
  
}
variable "name_prefix" {
  type    = string
  default = "clz"
}