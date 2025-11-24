variable "hcloud_token" {
  description = "Hetzner Cloud API token."
  type        = string
  sensitive   = true
}

variable "ssh_key_id" {
  description = "ID of SSH key to use for server access."
  type        = number
}
