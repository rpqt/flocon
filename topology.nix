{ config, ... }:
let
  inherit (config.lib.topology)
    mkConnection
    mkInternet
    mkRouter
    ;
in
{
  nodes.internet = mkInternet {
    connections = [
      (mkConnection "cassoulet" "wan1")
      (mkConnection "crocus" "enp1s0")
    ];
  };

  nodes.cassoulet = mkRouter "Cassoulet" {
    info = "BBox Fibre";
    interfaceGroups = [
      [ "wan1" ]
      [
        "eth1"
        "eth2"
        "eth3"
        "eth4"
      ]
    ];
  };

  networks.home = {
    name = "Home Network";
    cidrv4 = "192.168.1.1/24";
  };

  networks.tailscale = {
    name = "Tailscale";
    cidrv4 = "100.100.181.10/32";
    cidrv6 = "fd7a:115c:a1e0::2401:b50a/128";
  };
}
