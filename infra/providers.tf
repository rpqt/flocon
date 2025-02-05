provider "gandi" {
  personal_access_token = var.gandi_token
}

provider "hcloud" {
  token = var.hcloud_token
}
