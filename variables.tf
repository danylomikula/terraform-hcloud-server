variable "servers" {
  description = "Map of server configurations keyed by friendly name."
  type = map(object({
    server_type                = string
    location                   = optional(string)
    datacenter                 = optional(string)
    image                      = string
    ssh_keys                   = optional(list(number), [])
    keep_disk                  = optional(bool, false)
    iso                        = optional(number)
    rescue                     = optional(string)
    backups                    = optional(bool, false)
    ipv4_enabled               = optional(bool, true)
    ipv6_enabled               = optional(bool, true)
    firewall_ids               = optional(list(number), [])
    placement_group_id         = optional(number)
    user_data                  = optional(string)
    labels                     = optional(map(string), {})
    shutdown_before_deletion   = optional(bool, false)
    ignore_remote_firewall_ids = optional(bool, false)
    rebuild_protection         = optional(bool, false)
    delete_protection          = optional(bool, false)

    networks = optional(list(object({
      network_id = number
      ip         = optional(string)
      alias_ips  = optional(list(string), [])
    })), [])

    public_net = optional(object({
      ipv4_enabled = optional(bool, true)
      ipv6_enabled = optional(bool, true)
      ipv4         = optional(number)
      ipv6         = optional(number)
    }))
  }))
  default = {}
}

variable "common_ssh_keys" {
  description = "List of SSH key IDs to add to all servers in addition to per-server keys."
  type        = list(number)
  default     = []
}

variable "common_labels" {
  description = "Labels to apply to all servers in addition to per-server labels."
  type        = map(string)
  default     = {}
}

variable "common_firewall_ids" {
  description = "List of firewall IDs to apply to all servers in addition to per-server firewalls."
  type        = list(number)
  default     = []
}
