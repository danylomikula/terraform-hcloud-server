# Complete Example

This example demonstrates a full infrastructure setup with multiple modules working together.

## What it creates

- An SSH key pair (ED25519) saved locally
- A private network with subnet (10.0.0.0/16)
- A firewall with SSH, HTTP, HTTPS, and ICMP rules
- Two servers (`web-01`, `web-02`) with private network IPs

## Usage

```bash
export TF_VAR_hcloud_token="your-api-token"
terraform init
terraform apply
```

## Outputs

After applying, you can connect to the servers:

```bash
terraform output ssh_connection_commands
terraform output server_public_ips
terraform output server_private_ips
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.12.0 |
| <a name="requirement_hcloud"></a> [hcloud](#requirement\_hcloud) | >= 1.45.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_hcloud"></a> [hcloud](#provider\_hcloud) | >= 1.45.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_firewall"></a> [firewall](#module\_firewall) | danylomikula/firewall/hcloud | 1.0.0 |
| <a name="module_network"></a> [network](#module\_network) | danylomikula/network/hcloud | 1.0.0 |
| <a name="module_servers"></a> [servers](#module\_servers) | ../.. | n/a |
| <a name="module_ssh_key"></a> [ssh\_key](#module\_ssh\_key) | danylomikula/ssh-key/hcloud | 1.0.0 |

## Resources

| Name | Type |
|------|------|
| [hcloud_image.ubuntu](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/data-sources/image) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_hcloud_token"></a> [hcloud\_token](#input\_hcloud\_token) | Hetzner Cloud API token. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_firewall_ids"></a> [firewall\_ids](#output\_firewall\_ids) | IDs of the created firewalls. |
| <a name="output_network_id"></a> [network\_id](#output\_network\_id) | ID of the created network. |
| <a name="output_private_key_file"></a> [private\_key\_file](#output\_private\_key\_file) | Path to the saved private key file. |
| <a name="output_server_private_ips"></a> [server\_private\_ips](#output\_server\_private\_ips) | Private network IPs of all servers. |
| <a name="output_server_public_ips"></a> [server\_public\_ips](#output\_server\_public\_ips) | Public IPv4 addresses of all servers. |
| <a name="output_ssh_connection_commands"></a> [ssh\_connection\_commands](#output\_ssh\_connection\_commands) | Commands to connect to each server. |
<!-- END_TF_DOCS -->
