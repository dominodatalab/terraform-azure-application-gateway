resource "random_id" "name" {
  prefix      = "appgw-"
  byte_length = 8
}

locals {
  name = var.name == "" ? random_id.name.hex : var.name

  frontend_ip_configuration_name = "fe-ipconfig"
  https_port_name                = "https"
  http_port_name                 = "http"
  https_listener_name            = "https-listener"
  http_listener_name             = "http-listener"
  backend_address_pool_name      = "server-pool"
  backend_http_settings_name     = "http-settings"
  certificate_name               = "ssl-cert"
  health_probe_name              = "healthz"

  resource_group_name = reverse(split("/", var.resource_group_name))[0]
}
