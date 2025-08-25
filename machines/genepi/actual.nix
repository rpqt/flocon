{ config, ... }:
{
  services.actual = {
    enable = true;
    settings = {
      hostname = "127.0.0.1";
      port = 5555;
    };
  };

  services.nginx.virtualHosts."actual.home.rpqt.fr" = {
    forceSSL = true;
    useACMEHost = "home.rpqt.fr";
    locations."/".proxyPass =
      "http://127.0.0.1:${builtins.toString config.services.actual.settings.port}";
  };

  clan.core.state.acutal.folders = [ "/var/lib/actual" ];
}
