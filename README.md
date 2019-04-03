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
  object_id              = "user-object-id"

  # you can target the NICs of your VMs to add them to the backend pool for
  # this gateway. alternatively, you can pass "${module.my_appgw.backend_address_pool_id}"
  # to a VMSS.
  targets = ["${azurerm_network_interface.my_vms.*.name}"]
}
```
