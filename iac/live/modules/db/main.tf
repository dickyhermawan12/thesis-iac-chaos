resource "azurerm_mysql_server" "mysql_server" {
  name                = "${var.prefix}-mysql-server"
  location            = var.location
  resource_group_name = var.resource_group_name

  administrator_login          = var.mysql_db_username
  administrator_login_password = var.mysql_db_password

  sku_name   = "B_Gen5_1"
  storage_mb = 5120
  version    = "8.0"

  auto_grow_enabled                 = false
  backup_retention_days             = 7
  geo_redundant_backup_enabled      = false
  infrastructure_encryption_enabled = false
  public_network_access_enabled     = true
  ssl_enforcement_enabled           = false
  ssl_minimal_tls_version_enforced  = "TLSEnforcementDisabled"
  tags                              = var.tags
}

resource "azurerm_mysql_database" "mysql_db" {
  name                = "${var.prefix}-mysql-db"
  resource_group_name = var.resource_group_name
  server_name         = azurerm_mysql_server.mysql_server.name
  charset             = "utf8"
  collation           = "utf8_unicode_ci"
}

resource "azurerm_mysql_firewall_rule" "mysql_fw_rule" {
  name                = "allow-access-from-vnet"
  resource_group_name = var.resource_group_name
  server_name         = azurerm_mysql_server.mysql_server.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
}

resource "azurerm_mysql_virtual_network_rule" "mysql_virtual_network_rule" {
  name                = "mysql-vnet-rule"
  resource_group_name = var.resource_group_name
  server_name         = azurerm_mysql_server.mysql_server.name
  subnet_id           = var.db_subnet_id
}
