terraform {
  required_version = ">= 0.12"
}

provider "azurerm" {
  version = "~> 1.33.0"
}

provider "random" {
  version = "~> 2.1"
}
