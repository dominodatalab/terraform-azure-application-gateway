variable "resource_group_name" {
  description = ""
}

variable "subnet_id" {
  description = ""
}

variable "external_facing" {
  description = ""
  default     = false
}

variable "enable_http2" {
  description = ""
  default     = true
}

variable "disabled_ssl_protocols" {
  description = ""
  default     = ["TLSv1_0", "TLSv1_1"]
}

# sku settings
variable "sku_name" {
  description = ""
  default     = "Standard_Medium" # "Standard_v2"
}

variable "sku_tier" {
  description = ""
  default     = "Standard" # "Standard_v2"
}

variable "sku_capacity" {
  description = ""
  default     = 2
}

# backend pool settings
variable "cookie_based_affinity" {
  description = ""
  default     = "Disabled"
}

variable "backend_request_timeout" {
  description = ""
  default     = 60
}

variable "enable_connection_draining" {
  description = ""
  default     = false
}

variable "connection_drain_timeout" {
  description = ""
  default     = 300
}

# misc

variable "tags" {
  description = ""
  default     = {}
}
