data "gandi_livedns_domain" "rpqt_fr" {
  name = "rpqt.fr"
}

resource "gandi_livedns_record" "rpqt_fr_radicle_a" {
  zone = data.gandi_livedns_domain.rpqt_fr.id
  name = "radicle"
  type = "A"
  ttl  = 10800
  values = [
    hcloud_server.crocus_server.ipv4_address,
  ]
}

resource "gandi_livedns_record" "rpqt_fr_radicle_aaaa" {
  zone = data.gandi_livedns_domain.rpqt_fr.id
  name = "radicle"
  type = "AAAA"
  ttl  = 10800
  values = [
    hcloud_server.crocus_server.ipv6_address,
  ]
}

data "ovh_domain_zone" "turifer_dev" {
  name = "turifer.dev"
}

resource "ovh_domain_zone_import" "turifer_dev_import" {
  zone_name = "turifer.dev"
  zone_file = file("./turifer.dev.zone")
}
