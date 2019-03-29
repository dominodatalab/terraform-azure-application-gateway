locals {
  frontend_ip_configuration_name = "fe-ipconfig"
  frontend_port_name             = "http"
  http_listener_name             = "http-listener"

  backend_address_pool_name  = "pool-name"
  backend_http_settings_name = "http-settings"
}

data "azurerm_resource_group" "rg" { # TODO: uncouple location and rg?
  name = "${var.resource_group_name}"
}

# TODO: create VIP when creating public appgw

resource "random_uuid" "this" {}

resource "azurerm_application_gateway" "this" {
  name                = "appgw-${random_uuid.this.result}"
  resource_group_name = "${data.azurerm_resource_group.rg.name}"
  location            = "${data.azurerm_resource_group.rg.location}"

  enable_http2           = "${var.enable_http2}"
  disabled_ssl_protocols = ["${var.disabled_ssl_protocols}"]

  sku { # NOTE: this is fucking weird with v2 scale settings
    name     = "${var.sku_name}"
    tier     = "${var.sku_tier}"
    capacity = "${var.sku_capacity}"
  }

  gateway_ip_configuration {
    name      = "gateway-ipconfig"
    subnet_id = "${var.subnet_id}"
  }

  frontend_port {
    name = "${local.frontend_port_name}"
    port = 80
  }

  # NOTE: either publicIP or subnet should be specified; determines whether the
  #   gw is public or private
  frontend_ip_configuration {
    name                          = "${local.frontend_ip_configuration_name}"
    subnet_id                     = "${var.subnet_id}"
    private_ip_address_allocation = "Dynamic"
  }

  http_listener {
    name                           = "${local.http_listener_name}"
    frontend_ip_configuration_name = "${local.frontend_ip_configuration_name}"
    frontend_port_name             = "${local.frontend_port_name}"
    protocol                       = "Http"
  }

  backend_address_pool {
    name = "${local.backend_address_pool_name}"
  }

  backend_http_settings {
    name                  = "${local.backend_http_settings_name}"
    cookie_based_affinity = "${var.cookie_based_affinity}"
    port                  = 80
    protocol              = "Http"
    request_timeout       = "${var.backend_request_timeout}"
    # probe_name = ""

    connection_draining {
      enabled           = "${var.enable_connection_draining}"
      drain_timeout_sec = "${var.connection_drain_timeout}"
    }
  }

  request_routing_rule {
    name                       = "dem-rulz"
    rule_type                  = "Basic"
    http_listener_name         = "${local.http_listener_name}"
    backend_address_pool_name  = "${local.backend_address_pool_name}"
    backend_http_settings_name = "${local.backend_http_settings_name}"
  }

  tags = "${var.tags}"
}

# resource "azurerm_network_interface_application_gateway_backend_address_pool_association" "this" {
#   network_interface_id    = ""
#   ip_configuration_name   = ""
#   backend_address_pool_id = "${azurerm_application_gateway.this.backend_address_pool.0.id}"
# }
