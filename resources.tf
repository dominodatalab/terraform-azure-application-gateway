resource "azurerm_public_ip" "this" {
  name                = "${local.name}-vip"
  resource_group_name = "${var.resource_group_name}"
  location            = "${var.location}"
  sku                 = "Standard"
  allocation_method   = "Static"

  tags = "${var.tags}"
}

resource "azurerm_application_gateway" "this" {
  name                   = "${local.name}"
  resource_group_name    = "${var.resource_group_name}"
  location               = "${var.location}"
  enable_http2           = "${var.enable_http2}"
  disabled_ssl_protocols = ["${var.disabled_ssl_protocols}"]

  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 2
  }

  gateway_ip_configuration {
    name      = "gateway-ipconfig"
    subnet_id = "${var.subnet_id}"
  }

  frontend_ip_configuration {
    name                 = "${local.frontend_ip_configuration_name}"
    public_ip_address_id = "${azurerm_public_ip.this.id}"
  }

  frontend_port {
    name = "${local.https_port_name}"
    port = 443
  }

  frontend_port {
    name = "${local.http_port_name}"
    port = 80
  }

  ssl_certificate {
    name     = "${local.certificate_name}"
    data     = "${data.azurerm_key_vault_secret.cert.value}"
    password = ""
  }

  http_listener {
    name                           = "${local.https_listener_name}"
    frontend_ip_configuration_name = "${local.frontend_ip_configuration_name}"
    frontend_port_name             = "${local.https_port_name}"
    ssl_certificate_name           = "${local.certificate_name}"
    protocol                       = "Https"
  }

  http_listener {
    name                           = "${local.http_listener_name}"
    frontend_ip_configuration_name = "${local.frontend_ip_configuration_name}"
    frontend_port_name             = "${local.http_port_name}"
    protocol                       = "Http"
  }

  backend_address_pool {
    name = "${local.backend_address_pool_name}"
  }

  probe {
    name                = "${local.health_probe_name}"
    protocol            = "${var.health_probe_protocol}"
    interval            = "${var.health_probe_interval}"
    timeout             = "${var.health_probe_timeout}"
    unhealthy_threshold = "${var.health_probe_threshold}"
    path                = "${var.health_probe_path}"

    pick_host_name_from_backend_http_settings = true
  }

  backend_http_settings {
    name                  = "${local.backend_http_settings_name}"
    cookie_based_affinity = "${var.cookie_based_affinity}"
    port                  = 80
    protocol              = "Http"
    request_timeout       = "${var.backend_request_timeout}"
    probe_name            = "${local.health_probe_name}"

    pick_host_name_from_backend_address = true

    connection_draining {
      enabled           = "${var.enable_connection_draining}"
      drain_timeout_sec = "${var.connection_drain_timeout}"
    }
  }

  request_routing_rule {
    name                       = "https-routing"
    rule_type                  = "Basic"
    http_listener_name         = "${local.https_listener_name}"
    backend_address_pool_name  = "${local.backend_address_pool_name}"
    backend_http_settings_name = "${local.backend_http_settings_name}"
  }

  request_routing_rule {
    name                       = "http-routing"
    rule_type                  = "Basic"
    http_listener_name         = "${local.http_listener_name}"
    backend_address_pool_name  = "${local.backend_address_pool_name}"
    backend_http_settings_name = "${local.backend_http_settings_name}"
  }

  tags = "${var.tags}"
}

data "azurerm_network_interface" "targets" {
  count = "${length(var.targets)}"

  name                = "${var.targets[count.index]}"
  resource_group_name = "${var.resource_group_name}"
}

resource "azurerm_network_interface_application_gateway_backend_address_pool_association" "this" {
  count = "${length(var.targets)}"

  network_interface_id    = "${element(data.azurerm_network_interface.targets.*.id, count.index)}"
  ip_configuration_name   = "${element(data.azurerm_network_interface.targets.*.ip_configuration.0.name, count.index)}"
  backend_address_pool_id = "${azurerm_application_gateway.this.backend_address_pool.0.id}"
}
