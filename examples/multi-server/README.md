# Multi-Server Example

This example demonstrates managing multiple servers across different locations.

## What it creates

- Three application servers across locations (Nuremberg, Falkenstein, Helsinki)
- One database server with backups enabled
- Common labels applied to all servers

## Usage

```bash
export TF_VAR_hcloud_token="your-api-token"
terraform init
terraform plan -var="ssh_key_id=123"
terraform apply
```

## Outputs

After applying, you can view servers grouped by different criteria:

```bash
terraform output servers_by_location
terraform output servers_by_type
terraform output all_server_ips
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
| <a name="module_servers"></a> [servers](#module\_servers) | ../.. | n/a |

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
| <a name="output_all_server_ips"></a> [all\_server\_ips](#output\_all\_server\_ips) | Public IPv4 addresses of all servers. |
| <a name="output_server_ids"></a> [server\_ids](#output\_server\_ids) | IDs of all created servers. |
| <a name="output_servers_by_location"></a> [servers\_by\_location](#output\_servers\_by\_location) | Servers grouped by datacenter location. |
| <a name="output_servers_by_type"></a> [servers\_by\_type](#output\_servers\_by\_type) | Servers grouped by server type. |
<!-- END_TF_DOCS -->
