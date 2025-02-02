{ config, ... }:
let
  domain = "home.rpqt.fr";
  subdomain = "tw.${domain}";
in
{
  services.taskchampion-sync-server.enable = true;

  services.nginx.virtualHosts.${subdomain} = {
    forceSSL = true;
    useACMEHost = "${domain}";
    locations."/".proxyPass =
      "http://127.0.0.1:${toString config.services.taskchampion-sync-server.port}";
  };
}
