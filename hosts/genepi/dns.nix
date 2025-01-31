{ config, ... }:
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

        local-zone = [
          ''"grafana.home.rpqt.fr." redirect''
          ''"images.home.rpqt.fr" redirect''
        ];
        local-data = [
          ''"grafana.home.rpqt.fr. IN A 100.83.123.79"''
          ''"images.home.rpqt.fr. IN A 100.83.123.79"''
        ];
      };
    };
  };
}
