terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.45"
    }
    ovh = {
      source  = "ovh/ovh"
      version = "~> 2.5.0"
    }
    assert = {
      source = "hashicorp/assert"
    }
  }
}
