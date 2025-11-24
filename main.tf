locals {
  # Merge common and per-server configurations.
  servers_config = {
    for key, server in var.servers : key => {
      server_type                = server.server_type
      location                   = server.location
      datacenter                 = server.datacenter
      image                      = server.image
      ssh_keys                   = distinct(concat(var.common_ssh_keys, server.ssh_keys))
      keep_disk                  = server.keep_disk
      iso                        = server.iso
      rescue                     = server.rescue
      backups                    = server.backups
      ipv4_enabled               = server.ipv4_enabled
      ipv6_enabled               = server.ipv6_enabled
      firewall_ids               = distinct(concat(var.common_firewall_ids, server.firewall_ids))
      placement_group_id         = server.placement_group_id
      user_data                  = server.user_data
      labels                     = merge(var.common_labels, server.labels)
      shutdown_before_deletion   = server.shutdown_before_deletion
      ignore_remote_firewall_ids = server.ignore_remote_firewall_ids
      rebuild_protection         = server.rebuild_protection
      delete_protection          = server.delete_protection
      networks                   = server.networks
      public_net                 = server.public_net
    }
  }
}

resource "hcloud_server" "this" {
  for_each = local.servers_config

  name                       = each.key
  server_type                = each.value.server_type
  location                   = each.value.location
  datacenter                 = each.value.datacenter
  image                      = each.value.image
  ssh_keys                   = each.value.ssh_keys
  keep_disk                  = each.value.keep_disk
  iso                        = each.value.iso
  rescue                     = each.value.rescue
  backups                    = each.value.backups
  firewall_ids               = each.value.firewall_ids
  placement_group_id         = each.value.placement_group_id
  user_data                  = each.value.user_data
  labels                     = each.value.labels
  shutdown_before_deletion   = each.value.shutdown_before_deletion
  ignore_remote_firewall_ids = each.value.ignore_remote_firewall_ids
  rebuild_protection         = each.value.rebuild_protection
  delete_protection          = each.value.delete_protection

  dynamic "network" {
    for_each = each.value.networks
    content {
      network_id = network.value.network_id
      ip         = network.value.ip
      alias_ips  = network.value.alias_ips
    }
  }

  dynamic "public_net" {
    for_each = each.value.public_net != null ? [each.value.public_net] : []
    content {
      ipv4_enabled = public_net.value.ipv4_enabled
      ipv6_enabled = public_net.value.ipv6_enabled
      ipv4         = public_net.value.ipv4
      ipv6         = public_net.value.ipv6
    }
  }

  lifecycle {
    ignore_changes = [
      ssh_keys,
      user_data,
    ]
  }
}
