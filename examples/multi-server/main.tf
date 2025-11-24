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

# Multiple servers across locations.
module "servers" {
  source = "../.."

  servers = {
    app-nbg-01 = {
      server_type = "cx23"
      location    = "nbg1"
      image       = "ubuntu-24.04"
      ssh_keys    = [var.ssh_key_id]

      labels = {
        role     = "app"
        location = "nuremberg"
      }
    }

    app-fsn-01 = {
      server_type = "cx23"
      location    = "fsn1"
      image       = "ubuntu-24.04"
      ssh_keys    = [var.ssh_key_id]

      labels = {
        role     = "app"
        location = "falkenstein"
      }
    }

    app-hel-01 = {
      server_type = "cx23"
      location    = "hel1"
      image       = "ubuntu-24.04"
      ssh_keys    = [var.ssh_key_id]

      labels = {
        role     = "app"
        location = "helsinki"
      }
    }

    db-nbg-01 = {
      server_type = "cx33"
      location    = "nbg1"
      image       = "ubuntu-24.04"
      ssh_keys    = [var.ssh_key_id]
      backups     = true

      labels = {
        role = "database"
      }
    }
  }

  common_labels = {
    environment = "production"
    managed_by  = "terraform"
  }
}
