resource "hcloud_server" "crocus_server" {
  name         = "crocus"
  server_type  = "cx22"
  datacenter   = "nbg1-dc3"
  image        = "ubuntu-20.04"
  firewall_ids = [hcloud_firewall.crocus_firewall.id]
  public_net {
    ipv4 = hcloud_primary_ip.crocus_ipv4.id
  }
}

resource "hcloud_primary_ip" "crocus_ipv4" {
  name          = "crocus_ipv4"
  type          = "ipv4"
  datacenter    = "nbg1-dc3"
  assignee_type = "server"
  auto_delete   = true
}

resource "hcloud_firewall" "crocus_firewall" {
  name = "crocus-firewall"

  rule {
    direction  = "in"
    protocol   = "icmp"
    source_ips = ["0.0.0.0/0", "::/0"]
  }

  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = "22"
    source_ips = ["0.0.0.0/0", "::/0"]
  }

  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = "22"
    source_ips = ["0.0.0.0/0", "::/0"]
  }

  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = "80"
    source_ips = ["0.0.0.0/0", "::/0"]
  }

  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = "443"
    source_ips = ["0.0.0.0/0", "::/0"]
  }

  # radicle-node
  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = "8776"
    source_ips = ["0.0.0.0/0", "::/0"]
  }
}

output "crocus_ipv4" {
  value = hcloud_primary_ip.crocus_ipv4.ip_address
}
