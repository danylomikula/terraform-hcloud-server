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

# Basic single server.
module "server" {
  source = "../.."

  servers = {
    web-01 = {
      server_type = "cx23"
      location    = "nbg1"
      image       = "ubuntu-24.04"
      ssh_keys    = [var.ssh_key_id]

      labels = {
        role        = "webserver"
        environment = "production"
      }
    }
  }

  common_labels = {
    managed_by = "terraform"
    project    = "example"
  }
}
