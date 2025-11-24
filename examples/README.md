# Examples

This directory contains examples demonstrating how to use the Hetzner Cloud Server module.

## Available Examples

| Example | Description |
|---------|-------------|
| [basic](./basic/) | Single server deployment with minimal configuration |
| [complete](./complete/) | Full infrastructure with SSH key, network, firewall, and multiple servers |
| [multi-server](./multi-server/) | Multiple servers across different locations with mixed configurations |

## Usage

Each example can be run independently:

```bash
cd examples/basic
export TF_VAR_hcloud_token="your-api-token"
terraform init
terraform apply
```
