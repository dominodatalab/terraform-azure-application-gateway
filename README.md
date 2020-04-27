# Azure Application Gateway Terraform module

Terraform module that creates an application gateway with the following features:
- Public endpoint with a static IP
- Listeners defined on ports 443/80
- Configurable health probe
- Generates a self-signed certificate inside a dedicate Key Vault

## Usage

```hcl
module "my_appgw" {
  source = "git@github.com:cerebrotech/terraform-azure-application-gateway.git"

  location               = "westus2"
  resource_group_name    = "my-resource-group"
  subnet_id              = "my-subnet"

  # a password-protected ssl cert in pfx formwat is required
  ssl_cert_pfx_data      = data.external.cert.result["my-cert-data"]
  ssl_cert_pfx_password  = "mycertpassword"

  # you can target the NICs of your VMs to add them to the backend pool for
  # this gateway. alternatively, you can pass "${module.my_appgw.backend_address_pool_id}"
  # to a VMSS.
  targets = ["${azurerm_network_interface.my_vms.*.name}"]

  # or you can provide one or more IP addresses to target, useful if you
  # have reserved an ip address in terraform but won't have it setup as
  # a target until later (ie given to a k8s loadbalancer):
  backend_pool_ip_addresses = ["1.2.3.4"]
}
```
