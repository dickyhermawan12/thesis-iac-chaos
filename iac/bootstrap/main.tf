terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.59.0"
    }
  }

  # This block is specified after blob storage is created to store state remotely
  backend "azurerm" {
    resource_group_name  = "iac-thesis-rg"
    storage_account_name = "iacthesissa"
    container_name       = "iac-container"
    key                  = "bootstrap.terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}

# create resource group
resource "azurerm_resource_group" "rg" {
  name     = "iac-thesis-rg"
  location = var.location
  tags     = var.tags
}

# create storage account
resource "azurerm_storage_account" "sa" {
  name                     = "iacthesissa"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = var.tags
}

# create storage container for storing terraform state
resource "azurerm_storage_container" "sc" {
  name                  = "iac-container"
  storage_account_name  = azurerm_storage_account.sa.name
  container_access_type = "private"
}

