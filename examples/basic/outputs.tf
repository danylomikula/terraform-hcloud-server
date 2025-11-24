output "server_id" {
  description = "ID of the created server."
  value       = module.server.server_ids
}

output "server_ipv4" {
  description = "Public IPv4 address."
  value       = module.server.server_ipv4_addresses
}

output "server_ipv6" {
  description = "Public IPv6 address."
  value       = module.server.server_ipv6_addresses
}
