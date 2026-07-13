terraform {
    required_version =">=1.6.0"
    required_providers {
        azurerm = {
            source = "hashicorp/azurerm"
            version = " ~> 4.0" # attention, passage à la v4.x dans ce chapitre !

    }
    random = {
        source = "hashicorp/random"
        version = "~> 3.6"
    }
}
}