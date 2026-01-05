{ config, ... }:
let
  tld = "val";
  domain = "images.${tld}";
in
{
  services.immich = {
    enable = true;
    settings = {
      server.externalDomain = "https://${domain}";
    };
  };

  services.nginx.virtualHosts.${domain} = {
    forceSSL = true;
    enableACME = true;
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

  security.acme.certs.${domain}.server = "https://ca.${tld}/acme/acme/directory";

  clan.core.state.immich.folders = [ "/var/lib/immich" ];
}
