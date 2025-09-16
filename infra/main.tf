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
    ovh = {
      source  = "ovh/ovh"
      version = "2.5.0"
    }
    assert = {
      source = "hashicorp/assert"
    }
  }
}
