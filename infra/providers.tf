provider "gandi" {
  personal_access_token = var.gandi_token
}

provider "hcloud" {
  token = var.hcloud_token
}

provider "ovh" {
  endpoint      = "ovh-eu"
  client_id     = var.ovh_client_id
  client_secret = var.ovh_client_secret
}
