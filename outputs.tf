output "servers" {
  description = "Map of all server resources with complete attributes."
  value = {
    for key, server in hcloud_server.this : key => {
      id                 = server.id
      name               = server.name
      server_type        = server.server_type
      location           = server.location
      datacenter         = server.datacenter
      image              = server.image
      ipv4_address       = server.ipv4_address
      ipv6_address       = server.ipv6_address
      ipv6_network       = server.ipv6_network
      backup_window      = server.backup_window
      backups            = server.backups
      iso                = server.iso
      status             = server.status
      labels             = server.labels
      firewall_ids       = server.firewall_ids
      placement_group_id = server.placement_group_id
      rebuild_protection = server.rebuild_protection
      delete_protection  = server.delete_protection
    }
  }
}

output "server_ids" {
  description = "Map of server names to their IDs."
  value = {
    for key, server in hcloud_server.this : key => server.id
  }
}

output "server_ipv4_addresses" {
  description = "Map of server names to their IPv4 addresses."
  value = {
    for key, server in hcloud_server.this : key => server.ipv4_address
  }
}

output "server_ipv6_addresses" {
  description = "Map of server names to their IPv6 addresses."
  value = {
    for key, server in hcloud_server.this : key => server.ipv6_address
  }
}

output "servers_by_location" {
  description = "Map of locations to lists of server IDs in each location."
  value = {
    for location in distinct([for server in values(hcloud_server.this) : server.location]) :
    location => [
      for server in values(hcloud_server.this) : server.id
      if server.location == location
    ]
  }
}

output "servers_by_type" {
  description = "Map of server types to lists of server IDs of each type."
  value = {
    for type in distinct([for server in values(hcloud_server.this) : server.server_type]) :
    type => [
      for server in values(hcloud_server.this) : server.id
      if server.server_type == type
    ]
  }
}

output "private_network_ips" {
  description = "Map of server names to their private network IP addresses."
  value = {
    for key, server in hcloud_server.this : key => [
      for network in server.network : network.ip
    ]
  }
}
