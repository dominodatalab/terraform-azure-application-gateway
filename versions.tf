terraform {
  required_version = ">= 0.12"
}

provider "azurerm" {
  version = ">=2.3.0"
  features {}
}

provider "random" {
  version = "~> 2.1"
}
