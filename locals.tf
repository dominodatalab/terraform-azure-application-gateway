resource "random_uuid" "name_suffix" {}

locals {
  gateway_name = "${var.name == "" ? "appgw-${random_uuid.name_suffix.result}" : var.name}"

  frontend_ip_configuration_name = "fe-ipconfig"
  frontend_port_name             = "http"
  http_listener_name             = "http-listener"

  backend_address_pool_name  = "pool-name"
  backend_http_settings_name = "http-settings"
}
