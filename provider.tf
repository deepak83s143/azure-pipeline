terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.30.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "mademi-rg"
    storage_account_name = "mademisa"
    container_name       = "mademistatefiles"
    key                  = "azurepipeline.terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
  subscription_id = "171c73ab-6be7-46a1-8601-e56a64c29e2d"
}
