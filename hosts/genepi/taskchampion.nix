{ config, lib, ... }:
let
  domain = "home.rpqt.fr";
  subdomain = "tw.${domain}";
  hasImpermanence = config.environment.persistence."/persist".enable;
in
{
  services.taskchampion-sync-server.enable = true;

  services.taskchampion-sync-server.dataDir =
    (lib.optionalString hasImpermanence "/persist") + "/var/lib/taskchampion-sync-server";

  services.nginx.virtualHosts.${subdomain} = {
    forceSSL = true;
    useACMEHost = "${domain}";
    locations."/".proxyPass =
      "http://127.0.0.1:${toString config.services.taskchampion-sync-server.port}";
  };
}
