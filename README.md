# Hetzner Cloud Server Terraform Module

[![Release](https://img.shields.io/github/v/release/danylomikula/terraform-hcloud-server)](https://github.com/danylomikula/terraform-hcloud-server/releases)
[![Pre-Commit](https://github.com/danylomikula/terraform-hcloud-server/actions/workflows/pre-commit.yml/badge.svg)](https://github.com/danylomikula/terraform-hcloud-server/actions/workflows/pre-commit.yml)
[![License](https://img.shields.io/github/license/danylomikula/terraform-hcloud-server)](https://github.com/danylomikula/terraform-hcloud-server/blob/main/LICENSE)

Terraform module for managing Hetzner Cloud servers with full support for all provider features including private networks, firewalls, placement groups, and advanced configuration options.

## Features

- **Multi-server management**: Manage multiple servers with a single module invocation.
- **Private networking**: Attach servers to Hetzner Cloud private networks with static IPs.
- **Firewall integration**: Apply firewalls at server creation time.
- **Placement groups**: Control server placement for high availability or performance.
- **Flexible configuration**: Support for all hcloud_server resource attributes.
- **Common settings**: Apply SSH keys, labels, and firewalls to all servers.
- **Rich outputs**: Detailed server information grouped by location, type, and more.

## Usage

### Basic Single Server

```hcl
module "server" {
  source  = "danylomikula/server/hcloud"
  version = "~> 1.0"

  servers = {
    web-1 = {
      server_type = "cx23"
      location    = "nbg1"
      image       = "ubuntu-24.04"
      ssh_keys    = [12345]

      labels = {
        role = "webserver"
      }
    }
  }
}
```

### Servers with Private Network

```hcl
module "network" {
  source  = "danylomikula/network/hcloud"
  version = "~> 1.0"

  create_network = true
  name           = "app-network"
  ip_range       = "10.0.0.0/16"

  subnets = {
    main = {
      type         = "cloud"
      network_zone = "eu-central"
      ip_range     = "10.0.1.0/24"
    }
  }
}

module "servers" {
  source  = "danylomikula/server/hcloud"
  version = "~> 1.0"

  servers = {
    app-01 = {
      server_type = "cx23"
      location    = "nbg1"
      image       = "ubuntu-24.04"

      networks = [{
        network_id = module.network.network_id
        ip         = "10.0.1.10"
      }]
    }

    app-02 = {
      server_type = "cx23"
      location    = "fsn1"
      image       = "ubuntu-24.04"

      networks = [{
        network_id = module.network.network_id
        ip         = "10.0.1.11"
      }]
    }
  }

  common_ssh_keys = [12345]
  common_labels = {
    cluster    = "app"
    managed_by = "terraform"
  }
}
```

### Complete Example with SSH Key Generation

```hcl
# Generate SSH key.
module "ssh_key" {
  source  = "danylomikula/ssh-key/hcloud"
  version = "~> 1.0"

  create_key = true
  name       = "cluster-key"
  algorithm  = "ED25519"
}

# Create network.
module "network" {
  source  = "danylomikula/network/hcloud"
  version = "~> 1.0"

  create_network = true
  name           = "web-network"
  ip_range       = "10.100.0.0/16"

  subnets = {
    web = {
      type         = "cloud"
      network_zone = "eu-central"
      ip_range     = "10.100.1.0/24"
    }
  }
}

# Create servers.
module "server" {
  source  = "danylomikula/server/hcloud"
  version = "~> 1.0"

  servers = {
    web-1 = {
      server_type = "cx23"
      location    = "nbg1"
      image       = "ubuntu-24.04"

      networks = [{
        network_id = module.network.network_id
        ip         = "10.100.1.10"
      }]

      labels = {
        role = "webserver"
      }
    }
  }

  common_ssh_keys = [module.ssh_key.ssh_key_id]

  common_labels = {
    managed_by = "terraform"
  }
}
```

See [complete example](./examples/complete) for a full working configuration.

### Finding Available Server Types

**Install hcloud CLI**:
```bash
brew install hcloud
```

Setup guide: https://github.com/hetznercloud/cli/blob/main/docs/tutorials/setup-hcloud-cli.md

**List server types**:
```bash
hcloud server-type list
```

## Locations

**List locations**:
```bash
hcloud location list
```

**Documentation**: https://docs.hetzner.com/cloud/general/locations/

## Images

**List available images**:
```bash
# List all system images.
hcloud image list --type system

# Filter for specific OS.
hcloud image list --type system | grep ubuntu
hcloud image list --type system | grep rocky
```

### Dynamic Image Selection with Data Source

Use `hcloud_image` data source to automatically select the latest image:

```hcl
# Find latest Rocky Linux 9 for x86 architecture.
data "hcloud_image" "rocky9" {
  with_selector     = "os-flavor=rocky"
  with_architecture = "x86"
  most_recent       = true
}

# Find latest Ubuntu for ARM64.
data "hcloud_image" "ubuntu_arm" {
  name              = "ubuntu-24.04"
  with_architecture = "arm64"
}

# Use in server configuration.
module "servers" {
  source  = "danylomikula/server/hcloud"
  version = "~> 1.0"

  servers = {
    app-01 = {
      server_type = "cx23"
      image       = data.hcloud_image.rocky9.name  # Uses latest Rocky 9.
      location    = "nbg1"
    }

    app-arm = {
      server_type = "cax11"  # ARM64 server.
      image       = data.hcloud_image.ubuntu_arm.name
      location    = "fsn1"
    }
  }
}
```

**Data source reference**: https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/data-sources/image

**Available selectors**:
- `os-flavor=ubuntu` / `rocky` / `debian` / `fedora`
- `os-version=22.04` / `9` / `12`

**Architectures**:
- `x86` - Standard Intel/AMD (cx, ccx series)
- `arm` - ARM64 (cax series)

## Best Practices

1. **Use private networks** for inter-server communication.
2. **Enable backups** for production servers.
3. **Apply firewalls** to restrict access.
4. **Use placement groups** for high availability.
5. **Set labels** for organization and management.
6. **Use common_*** variables** to reduce duplication.
7. **Generate SSH keys** via the ssh-key module.

## Lifecycle Considerations

The module uses `ignore_changes` for:
- `ssh_keys`: Prevents recreation when keys are added manually.
- `user_data`: Prevents recreation when cloud-init data changes.

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

No modules.

## Resources

| Name | Type |
|------|------|
| [hcloud_server.this](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/server) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_common_firewall_ids"></a> [common\_firewall\_ids](#input\_common\_firewall\_ids) | List of firewall IDs to apply to all servers in addition to per-server firewalls. | `list(number)` | `[]` | no |
| <a name="input_common_labels"></a> [common\_labels](#input\_common\_labels) | Labels to apply to all servers in addition to per-server labels. | `map(string)` | `{}` | no |
| <a name="input_common_ssh_keys"></a> [common\_ssh\_keys](#input\_common\_ssh\_keys) | List of SSH key IDs to add to all servers in addition to per-server keys. | `list(number)` | `[]` | no |
| <a name="input_servers"></a> [servers](#input\_servers) | Map of server configurations keyed by friendly name. | <pre>map(object({<br/>    server_type                = string<br/>    location                   = optional(string)<br/>    datacenter                 = optional(string)<br/>    image                      = string<br/>    ssh_keys                   = optional(list(number), [])<br/>    keep_disk                  = optional(bool, false)<br/>    iso                        = optional(number)<br/>    rescue                     = optional(string)<br/>    backups                    = optional(bool, false)<br/>    ipv4_enabled               = optional(bool, true)<br/>    ipv6_enabled               = optional(bool, true)<br/>    firewall_ids               = optional(list(number), [])<br/>    placement_group_id         = optional(number)<br/>    user_data                  = optional(string)<br/>    labels                     = optional(map(string), {})<br/>    shutdown_before_deletion   = optional(bool, false)<br/>    ignore_remote_firewall_ids = optional(bool, false)<br/>    rebuild_protection         = optional(bool, false)<br/>    delete_protection          = optional(bool, false)<br/><br/>    networks = optional(list(object({<br/>      network_id = number<br/>      ip         = optional(string)<br/>      alias_ips  = optional(list(string), [])<br/>    })), [])<br/><br/>    public_net = optional(object({<br/>      ipv4_enabled = optional(bool, true)<br/>      ipv6_enabled = optional(bool, true)<br/>      ipv4         = optional(number)<br/>      ipv6         = optional(number)<br/>    }))<br/>  }))</pre> | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_private_network_ips"></a> [private\_network\_ips](#output\_private\_network\_ips) | Map of server names to their private network IP addresses. |
| <a name="output_server_ids"></a> [server\_ids](#output\_server\_ids) | Map of server names to their IDs. |
| <a name="output_server_ipv4_addresses"></a> [server\_ipv4\_addresses](#output\_server\_ipv4\_addresses) | Map of server names to their IPv4 addresses. |
| <a name="output_server_ipv6_addresses"></a> [server\_ipv6\_addresses](#output\_server\_ipv6\_addresses) | Map of server names to their IPv6 addresses. |
| <a name="output_servers"></a> [servers](#output\_servers) | Map of all server resources with complete attributes. |
| <a name="output_servers_by_location"></a> [servers\_by\_location](#output\_servers\_by\_location) | Map of locations to lists of server IDs in each location. |
| <a name="output_servers_by_type"></a> [servers\_by\_type](#output\_servers\_by\_type) | Map of server types to lists of server IDs of each type. |
<!-- END_TF_DOCS -->

## Related Modules

| Module | Description | GitHub | Terraform Registry |
|--------|-------------|--------|-------------------|
| **terraform-hcloud-network** | Manage Hetzner Cloud networks and subnets | [GitHub](https://github.com/danylomikula/terraform-hcloud-network) | [Registry](https://registry.terraform.io/modules/danylomikula/network/hcloud) |
| **terraform-hcloud-firewall** | Manage Hetzner Cloud firewalls | [GitHub](https://github.com/danylomikula/terraform-hcloud-firewall) | [Registry](https://registry.terraform.io/modules/danylomikula/firewall/hcloud) |
| **terraform-hcloud-ssh-key** | Manage Hetzner Cloud SSH keys | [GitHub](https://github.com/danylomikula/terraform-hcloud-ssh-key) | [Registry](https://registry.terraform.io/modules/danylomikula/ssh-key/hcloud) |

## Authors

Module managed by [Danylo Mikula](https://github.com/danylomikula).

## Contributing

Contributions are welcome! Please read the [Contributing Guide](.github/contributing.md) for details on the process and commit conventions.

## License

Apache 2.0 Licensed. See [LICENSE](LICENSE) for full details.
