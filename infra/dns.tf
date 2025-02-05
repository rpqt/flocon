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
