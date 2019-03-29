output "id" {
  description = "The ID of the application gateway"
  value       = "${azurerm_application_gateway.this.id}"
}

output "backend_address_pool_id" {
  description = "The ID of the application gateway backend address pool"
  value       = "${azurerm_application_gateway.this.backend_address_pool.0.id}"
}
