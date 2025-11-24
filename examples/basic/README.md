# Basic Example

This example demonstrates how to deploy a single server with minimal configuration.

## What it creates

- A single server `web-01` (cx23) in Nuremberg (nbg1)
- Ubuntu 24.04 image
- Labels for organization (`role=webserver`, `environment=production`, `managed_by=terraform`)

## Usage

```bash
export TF_VAR_hcloud_token="your-api-token"
terraform init
terraform plan -var="ssh_key_id=123"
terraform apply
```

## Outputs

After applying, you can connect to the server:

```bash
terraform output server_ipv4
ssh root@<server-ip>
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.12.0 |
| <a name="requirement_hcloud"></a> [hcloud](#requirement\_hcloud) | >= 1.45.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_server"></a> [server](#module\_server) | ../.. | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_hcloud_token"></a> [hcloud\_token](#input\_hcloud\_token) | Hetzner Cloud API token. | `string` | n/a | yes |
| <a name="input_ssh_key_id"></a> [ssh\_key\_id](#input\_ssh\_key\_id) | ID of SSH key to use for server access. | `number` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_server_id"></a> [server\_id](#output\_server\_id) | ID of the created server. |
| <a name="output_server_ipv4"></a> [server\_ipv4](#output\_server\_ipv4) | Public IPv4 address. |
| <a name="output_server_ipv6"></a> [server\_ipv6](#output\_server\_ipv6) | Public IPv6 address. |
<!-- END_TF_DOCS -->
