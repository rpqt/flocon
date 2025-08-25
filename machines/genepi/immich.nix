{ config, ... }:
let
  domain = "home.rpqt.fr";
  subdomain = "images.${domain}";
in
{
  services.immich = {
    enable = true;
    settings = {
      server.externalDomain = "https://${subdomain}";
    };
  };

  services.nginx.virtualHosts.${subdomain} = {
    forceSSL = true;
    useACMEHost = "${domain}";
    locations."/" = {
      proxyPass = "http://${toString config.services.immich.host}:${toString config.services.immich.port}";
      proxyWebsockets = true;
      extraConfig = ''
        client_max_body_size 50000M;
        proxy_read_timeout 600s;
        proxy_send_timeout 600s;
        send_timeout 600s;
      '';
    };
  };

  clan.core.state.immich.folders = [ "/var/lib/immich" ];
}
