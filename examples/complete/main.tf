terraform {
  required_version = ">= 1.12.0"

  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = ">= 1.45.0"
    }
  }
}

provider "hcloud" {
  token = var.hcloud_token
}

################################################################################
# Data Sources
################################################################################

data "hcloud_image" "ubuntu" {
  name              = "ubuntu-24.04"
  with_architecture = "x86"
  most_recent       = true
}

################################################################################
# SSH Key
################################################################################

module "ssh_key" {
  source  = "danylomikula/ssh-key/hcloud"
  version = "1.0.0"

  create_key = true
  name       = "example-key"
  algorithm  = "ED25519"

  save_private_key_locally = true
  local_key_directory      = path.module

  labels = {
    environment = "production"
    managed_by  = "terraform"
  }
}

################################################################################
# Network
################################################################################

module "network" {
  source  = "danylomikula/network/hcloud"
  version = "1.0.0"

  create_network = true
  name           = "web-network"
  ip_range       = "10.0.0.0/16"

  labels = {
    environment = "production"
    managed_by  = "terraform"
  }

  subnets = {
    web = {
      type         = "cloud"
      network_zone = "eu-central"
      ip_range     = "10.0.1.0/24"
    }
  }
}

################################################################################
# Firewall
################################################################################

module "firewall" {
  source  = "danylomikula/firewall/hcloud"
  version = "1.0.0"

  firewalls = {
    web = {
      rules = [
        {
          direction  = "in"
          protocol   = "tcp"
          port       = "22"
          source_ips = ["0.0.0.0/0", "::/0"]
        },
        {
          direction  = "in"
          protocol   = "tcp"
          port       = "80"
          source_ips = ["0.0.0.0/0", "::/0"]
        },
        {
          direction  = "in"
          protocol   = "tcp"
          port       = "443"
          source_ips = ["0.0.0.0/0", "::/0"]
        },
        {
          direction  = "in"
          protocol   = "icmp"
          source_ips = ["0.0.0.0/0", "::/0"]
        }
      ]
    }
  }

  common_labels = {
    environment = "production"
    managed_by  = "terraform"
  }
}

################################################################################
# Servers
################################################################################

module "servers" {
  source = "../.."

  servers = {
    web-01 = {
      server_type = "cx23"
      location    = "nbg1"
      image       = data.hcloud_image.ubuntu.name

      networks = [{
        network_id = module.network.network_id
        ip         = "10.0.1.10"
      }]

      labels = {
        role = "webserver"
        node = "primary"
      }
    }

    web-02 = {
      server_type = "cx23"
      location    = "fsn1"
      image       = data.hcloud_image.ubuntu.name

      networks = [{
        network_id = module.network.network_id
        ip         = "10.0.1.11"
      }]

      labels = {
        role = "webserver"
        node = "secondary"
      }
    }
  }

  common_ssh_keys     = [module.ssh_key.ssh_key_id]
  common_firewall_ids = [module.firewall.firewall_ids["web"]]

  common_labels = {
    cluster    = "web"
    managed_by = "terraform"
  }
}
