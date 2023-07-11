terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.64.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "iac-thesis-rg"
    storage_account_name = "iacthesissa"
    container_name       = "iac-container"
    key                  = "live.terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}

data "terraform_remote_state" "bootstrap" {
  backend = "azurerm"

  config = {
    resource_group_name  = "iac-thesis-rg"
    storage_account_name = "iacthesissa"
    container_name       = "iac-container"
    key                  = "bootstrap.terraform.tfstate"
  }
}

module "vnet" {
  source                 = "./modules/vnet"
  prefix                 = var.prefix
  tags                   = var.tags
  location               = var.location
  resource_group_name    = data.terraform_remote_state.bootstrap.outputs.resource_group_name
  vnet_address_space     = var.vnet_address_space
  agw_subnet_address     = var.agw_subnet_address
  jumpbox_subnet_address = var.jumpbox_subnet_address
  web_subnet_address     = var.web_subnet_address
  app_subnet_address     = var.app_subnet_address
  db_subnet_address      = var.db_subnet_address
}

module "nsg" {
  source                 = "./modules/nsg"
  prefix                 = var.prefix
  tags                   = var.tags
  location               = var.location
  resource_group_name    = data.terraform_remote_state.bootstrap.outputs.resource_group_name
  agw_subnet_id          = module.vnet.agw_subnet_id
  jumpbox_subnet_id      = module.vnet.jumpbox_subnet_id
  web_subnet_id          = module.vnet.web_subnet_id
  app_subnet_id          = module.vnet.app_subnet_id
  db_subnet_id           = module.vnet.db_subnet_id
  agw_subnet_address     = var.agw_subnet_address
  web_subnet_address     = var.web_subnet_address
  app_subnet_address     = var.app_subnet_address
  jumpbox_subnet_address = var.jumpbox_subnet_address
}

module "lb" {
  source              = "./modules/lb"
  prefix              = var.prefix
  tags                = var.tags
  location            = var.location
  resource_group_name = data.terraform_remote_state.bootstrap.outputs.resource_group_name
  agw_subnet_id       = module.vnet.agw_subnet_id
  app_subnet_id       = module.vnet.app_subnet_id
  app_lb_private_ip   = var.app_lb_private_ip
}

module "natgw" {
  source              = "./modules/natgw"
  prefix              = var.prefix
  tags                = var.tags
  location            = var.location
  resource_group_name = data.terraform_remote_state.bootstrap.outputs.resource_group_name
  subnet_id           = module.vnet.app_subnet_id
}

module "db" {
  source              = "./modules/db"
  prefix              = var.prefix
  tags                = var.tags
  location            = var.location
  resource_group_name = data.terraform_remote_state.bootstrap.outputs.resource_group_name
  virtual_network_id  = module.vnet.virtual_network_id
  db_subnet_id        = module.vnet.db_subnet_id
  mysql_db_username   = var.mysql_db_username
  mysql_db_password   = var.mysql_db_password
  mysql_db_schema     = var.mysql_db_schema
}

module "jumpbox" {
  source              = "./modules/jumpbox"
  prefix              = var.prefix
  tags                = var.tags
  location            = var.location
  resource_group_name = data.terraform_remote_state.bootstrap.outputs.resource_group_name
  jumpbox_subnet_id   = module.vnet.jumpbox_subnet_id

  depends_on = [module.db]
}

module "vmss" {
  source                         = "./modules/vmss"
  prefix                         = var.prefix
  tags                           = var.tags
  location                       = var.location
  resource_group_name            = data.terraform_remote_state.bootstrap.outputs.resource_group_name
  web_nsg_id                     = module.nsg.web_nsg_id
  app_nsg_id                     = module.nsg.app_nsg_id
  web_subnet_id                  = module.vnet.web_subnet_id
  app_subnet_id                  = module.vnet.app_subnet_id
  web_lb_backend_address_pool_id = module.lb.agw_backend_address_pool_id
  app_lb_backend_address_pool_id = module.lb.app_lb_backend_address_pool_id
  web_source_image_id            = var.web_source_image_id
  app_source_image_id            = var.app_source_image_id

  depends_on = [module.jumpbox]
}

module "autoscale" {
  source              = "./modules/autoscale"
  prefix              = var.prefix
  tags                = var.tags
  location            = var.location
  resource_group_name = data.terraform_remote_state.bootstrap.outputs.resource_group_name
  web_vmss_id         = module.vmss.web_vmss_id
  app_vmss_id         = module.vmss.app_vmss_id
}
