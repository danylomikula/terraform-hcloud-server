output "private_key_file" {
  description = "Path to the saved private key file."
  value       = module.ssh_key.private_key_file_path
}

output "network_id" {
  description = "ID of the created network."
  value       = module.network.network_id
}

output "firewall_ids" {
  description = "IDs of the created firewalls."
  value       = module.firewall.firewall_ids
}

output "server_public_ips" {
  description = "Public IPv4 addresses of all servers."
  value       = module.servers.server_ipv4_addresses
}

output "server_private_ips" {
  description = "Private network IPs of all servers."
  value       = module.servers.private_network_ips
}

output "ssh_connection_commands" {
  description = "Commands to connect to each server."
  value = {
    for name, ip in module.servers.server_ipv4_addresses :
    name => "ssh -i ${module.ssh_key.private_key_file_path} root@${ip}"
  }
}
