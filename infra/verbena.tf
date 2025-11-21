output "verbena_ipv4" {
  value = local.verbena_ipv4_addresses[0]
}

output "verbena_ipv6" {
  value = local.verbena_ipv6_addresses[0]
}

output "verbena_gateway6" {
  value = local.gateway6
}

locals {
  hextets      = 4
  parts        = split(":", local.verbena_ipv6_addresses[0])
  prefix_parts = slice(local.parts, 0, local.hextets)
  prefix_str   = join(":", local.prefix_parts)
  gateway6     = "${local.prefix_str}::1"
}

