{ config, ... }:
let
  domain = "home.rpqt.fr";
in
{
  services.grafana = {
    enable = true;
    settings = {
      server = {
        http_port = 3000;
        domain = "grafana.${domain}";
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
    useACMEHost = "${domain}";
    locations."/" = {
      proxyPass = "http://127.0.0.1:${toString config.services.grafana.settings.server.http_port}";
      proxyWebsockets = true;
    };
  };
}
