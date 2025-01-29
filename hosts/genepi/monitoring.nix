{ config, ... }:
{
  services.grafana = {
    enable = true;
    settings = {
      server = {
        http_port = 3000;
        domain = "grafana.home.rpqt.fr";
      };
    };
  };

  services.nginx.virtualHosts.${config.services.grafana.settings.server.domain} = {
    forceSSL = true;
    useACMEHost = "home.rpqt.fr";
    locations."/" = {
      proxyPass = "http://127.0.0.1:${toString config.services.grafana.settings.server.http_port}";
      proxyWebsockets = true;
    };
  };

  services.prometheus = {
    enable = true;
    port = 9001;

    scrapeConfigs = [
      {
        job_name = "genepi";
        static_configs = [
          {
            targets = [ "127.0.0.1:${toString config.services.prometheus.exporters.node.port}" ];
          }
        ];
      }
      {
        job_name = "crocus";
        static_configs = [
          {
            targets = [ "crocus:9002" ];
          }
        ];
      }
    ];

    exporters = {
      node = {
        enable = true;
        enabledCollectors = [ "systemd" ];
        port = 9002;
      };
    };
  };
}
