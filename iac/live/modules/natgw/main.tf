resource "azurerm_public_ip" "natgw_public_ip" {
  name                = "${var.prefix}-natgw-public-ip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_nat_gateway" "natgw" {
  name                = "${var.prefix}-natgw"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku_name            = "Standard"
  tags                = var.tags
}

resource "azurerm_nat_gateway_public_ip_association" "natgw_public_ip_assoc" {
  nat_gateway_id       = azurerm_nat_gateway.natgw.id
  public_ip_address_id = azurerm_public_ip.natgw_public_ip.id
}

resource "azurerm_subnet_nat_gateway_association" "natgw_subnet_assoc" {
  subnet_id      = var.subnet_id
  nat_gateway_id = azurerm_nat_gateway.natgw.id
}
