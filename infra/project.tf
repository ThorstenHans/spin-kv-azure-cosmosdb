terraform {
  required_version = "~>1.4.6"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.55.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.5.1"
    }

  }
}

provider "random" {

}
provider "azurerm" {
  features {}
}
