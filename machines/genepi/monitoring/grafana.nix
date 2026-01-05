{ config, ... }:
let
  tld = "val";
in
{
  services.grafana = {
    enable = true;
    settings = {
      server = {
        http_port = 3000;
        domain = "grafana.${tld}";
      };
    };
    provision = {
      enable = true;
      datasources = {
        settings = {
          datasources = [
            {
              name = "Prometheus";
              type = "prometheus";
              access = "proxy";
              url = "http://127.0.0.1:${toString config.services.prometheus.port}";
              isDefault = true;
            }
          ];
        };
      };
    };
  };

  services.nginx.virtualHosts.${config.services.grafana.settings.server.domain} = {
    forceSSL = true;
    enableACME = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:${toString config.services.grafana.settings.server.http_port}";
      proxyWebsockets = true;
    };
  };

  security.acme.certs.${config.services.grafana.settings.server.domain}.server =
    "https://ca.${tld}/acme/acme/directory";
}
