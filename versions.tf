terraform {
  required_version = ">= 0.12"
}

provider "azurerm" {
  version = ">=2.7.0"
  features {}
  partner_id = "31912fbf-f6dd-5176-bffb-0a01e8ac71f2"
}

provider "random" {
  version = "~> 2.1"
}
