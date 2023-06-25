resource "azurerm_private_dns_zone" "private_dns_zone" {
  name                = "${var.prefix}.mysql.database.azure.com"
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "private_dns_vnet_link" {
  name                  = "mysqlfsVnetZone-iacthesis-db.com"
  private_dns_zone_name = azurerm_private_dns_zone.private_dns_zone.name
  resource_group_name   = var.resource_group_name
  virtual_network_id    = var.virtual_network_id
}

resource "azurerm_mysql_flexible_server" "db_mysql_server" {
  resource_group_name          = var.resource_group_name
  location                     = var.location
  name                         = "${var.prefix}-mysqlfs-db"
  administrator_login          = var.mysql_db_username
  administrator_password       = var.mysql_db_password
  backup_retention_days        = 7
  delegated_subnet_id          = var.db_subnet_id
  geo_redundant_backup_enabled = false
  private_dns_zone_id          = azurerm_private_dns_zone.private_dns_zone.id
  sku_name                     = "B_Standard_B1s"
  version                      = "8.0.21"
  tags                         = var.tags

  storage {
    iops    = 360
    size_gb = 20
  }

  depends_on = [azurerm_private_dns_zone_virtual_network_link.private_dns_vnet_link]
}

resource "azurerm_mysql_flexible_database" "db_mysql_database" {
  name                = var.mysql_db_schema
  resource_group_name = var.resource_group_name
  server_name         = azurerm_mysql_flexible_server.db_mysql_server.name
  charset             = "utf8mb4"
  collation           = "utf8mb4_unicode_ci"
}
