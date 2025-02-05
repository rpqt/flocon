terraform {
  required_providers {
    gandi = {
      source  = "go-gandi/gandi"
      version = "2.3.0"
    }
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.45"
    }
  }
}
