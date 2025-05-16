{ config, ... }:
let
  domain = "home.rpqt.fr";
  subdomain = "glance.${domain}";
in
{
  services.glance = {
    enable = true;
    settings = ./glance-config.nix;
  };

  services.nginx.virtualHosts.${subdomain} = {
    forceSSL = true;
    useACMEHost = "${domain}";
    locations."/".proxyPass =
      "http://127.0.0.1:${toString config.services.glance.settings.server.port}";
  };
}
