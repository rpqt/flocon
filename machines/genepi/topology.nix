{ config, ... }:
let
  inherit (config.lib.topology)
    mkConnection
    ;
in
{
  topology.self = {
    hardware.info = "Raspberry Pi 4B";
    interfaces = {
      tailscale0 = {
        type = "wireguard";
        network = "tailscale";
      };
      enp1s0 = {
        type = "ethernet";
        network = "home";
        physicalConnections = [
          (mkConnection "cassoulet" "eth1")
        ];
      };
    };
  };
}
