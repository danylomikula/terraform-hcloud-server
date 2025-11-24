output "servers_by_location" {
  description = "Servers grouped by datacenter location."
  value       = module.servers.servers_by_location
}

output "servers_by_type" {
  description = "Servers grouped by server type."
  value       = module.servers.servers_by_type
}

output "all_server_ips" {
  description = "Public IPv4 addresses of all servers."
  value       = module.servers.server_ipv4_addresses
}

output "server_ids" {
  description = "IDs of all created servers."
  value       = module.servers.server_ids
}
