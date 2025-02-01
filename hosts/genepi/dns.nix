{ config, lib, ... }:
let
  domain = "home.rpqt.fr";
  genepi = {
    ip = "100.83.123.79";
    subdomains = [
      "grafana"
      "images"
      "rss"
    ];
  };
in
{
  networking.firewall.interfaces."${config.services.tailscale.interfaceName}" = {
    allowedTCPPorts = [ 53 ];
    allowedUDPPorts = [ 53 ];
  };

  services.unbound = {
    enable = true;
    resolveLocalQueries = false;

    settings = {
      server = {
        interface = [ "${config.services.tailscale.interfaceName}" ];
        access-control = [ "100.0.0.0/8 allow" ];

        local-zone = lib.map (subdomain: ''"${subdomain}.${domain}." redirect'') genepi.subdomains;
        local-data = lib.map (subdomain: ''"${subdomain}.${domain}. IN A ${genepi.ip}"'') genepi.subdomains;
      };
    };
  };

  systemd.services.unbound.after = [ "tailscaled.service" ];

  systemd.services.tailscaled.after = [
    "network-online.target"
    "systemd-resolved.service"
  ];
}
