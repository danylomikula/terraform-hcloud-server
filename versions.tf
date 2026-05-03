terraform {
  required_version = ">= 1.13.0"

  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = ">= 1.62.0"
    }
  }
}
