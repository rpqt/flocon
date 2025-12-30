data "ovh_vps" "verbena_vps" {
  service_name = "vps-7e78bac2.vps.ovh.net"
}

data "ovh_domain_zone" "rpqt_fr" {
  name = "rpqt.fr"
}

resource "ovh_domain_zone_import" "rpqt_fr_import" {
  zone_name = "rpqt.fr"
  zone_file = local.rpqt_fr_zone_file
}


data "ovh_domain_zone" "turifer_dev" {
  name = "turifer.dev"
}

resource "ovh_domain_zone_import" "turifer_dev_import" {
  zone_name = "turifer.dev"
  zone_file = local.turifer_dev_zone_file
}

locals {
  verbena_ipv4_addresses = [for ip in data.ovh_vps.verbena_vps.ips : ip if provider::assert::ipv4(ip)]
  verbena_ipv6_addresses = [for ip in data.ovh_vps.verbena_vps.ips : ip if provider::assert::ipv6(ip)]

  turifer_dev_zone_file = templatefile("./templates/turifer.dev.zone", {
    crocus_ipv4_address = hcloud_server.crocus_server.ipv4_address
    crocus_ipv6_address = hcloud_server.crocus_server.ipv6_address

    verbena_ipv4_addresses = local.verbena_ipv4_addresses
    verbena_ipv6_addresses = local.verbena_ipv6_addresses
  })

  rpqt_fr_zone_file = templatefile("./templates/turifer.dev.zone", {
    crocus_ipv4_address = hcloud_server.crocus_server.ipv4_address
    crocus_ipv6_address = hcloud_server.crocus_server.ipv6_address

    verbena_ipv4_addresses = local.verbena_ipv4_addresses
    verbena_ipv6_addresses = local.verbena_ipv6_addresses
  })
}

