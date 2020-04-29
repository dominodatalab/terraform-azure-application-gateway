#------------------------------------------------------------------------------
# REQUIRED
#------------------------------------------------------------------------------

variable "location" {
  description = "Azure Region where the gateway will be created"
}

variable "resource_group_name" {
  description = "Resource group that will contain the gateway"
}

variable "subnet_id" {
  description = "Subnet where the gateway will create its NIC"
}

#------------------------------------------------------------------------------
# OPTIONAL
#------------------------------------------------------------------------------

variable "name" {
  description = "Root name applied to all resources. A dynamic name will be generated if none is provided"
  default     = ""
}

variable "targets" {
  description = "List of NIC IDs targeted by the application gateway's backend pool"
  default     = []
}

variable "backend_pool_ip_addresses" {
  description = "IP Addresses in the default backend address pool"
  default     = []
}

variable "enable_http2" {
  description = "Enable the HTTP/2 protocol"
  default     = true
}

variable "ssl_cert_pfx_data" {
  description = "Password-protected PFX format SSL cert to install into AGW"
}

variable "ssl_cert_pfx_password" {
  description = "Password for PFX formatted SSL cert (required with SSL)"
}

variable "disabled_ssl_protocols" {
  description = "List of ssl protocols which should be disabled on this application gateway"
  default     = ["TLSv1_0", "TLSv1_1"]
}

variable "cookie_based_affinity" {
  description = "Specify Enabled or Disabled. Controls cookie-based session affinity to backend pool members"
  default     = "Disabled"
}

variable "backend_request_timeout" {
  description = "Number of seconds to wait for a backend pool member to respond"
  default     = 60
}

variable "enable_connection_draining" {
  description = "Enable connection draining to change members within a backend pool without disruption"
  default     = false
}

variable "connection_drain_timeout" {
  description = "Number of seconds to wait before for active connections to drain out of a removed backend pool member"
  default     = 300
}

variable "health_probe_protocol" {
  description = "Protocol used to by health probe"
  default     = "Http"
}

variable "health_probe_interval" {
  description = "Interval between two consecutive probes in seconds"
  default     = 30
}

variable "health_probe_timeout" {
  description = "Probe is marked as failed if valid response within this timeout period in seconds"
  default     = 30
}

variable "health_probe_threshold" {
  description = "Indicates the amount of retries which should be attempted before a pool member is deemed unhealthy"
  default     = 3
}

variable "health_probe_path" {
  description = "Path used by health probe"
  default     = "/"
}

variable "tags" {
  description = "A mapping of tags to assign to all resources"
  default     = {}
}
