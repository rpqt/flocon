{
  config,
  lib,
  self,
  ...
}:
let
  domain = "home.rpqt.fr";

  allHosts = self.nixosConfigurations;

  hostInTailnetFilter = k: v: v.config.services.tailscale.enable;
  tailnetHosts = lib.filterAttrs hostInTailnetFilter allHosts;

  # Explicitly list the exporters as some are deprecated and can't be evaluated
  possibleExporterNames = [
    "node"
  ];

  getEnabledExporters =
    hostname: host:
    lib.filterAttrs (k: v: v.enable == true) (
      lib.getAttrs possibleExporterNames host.config.services.prometheus.exporters
    );
  enabledExporters = lib.mapAttrs getEnabledExporters tailnetHosts;

  mkScrapeConfigExporter = hostname: exporterName: exporterCfg: {
    job_name = "${hostname}-${exporterName}";
    static_configs = [ { targets = [ "${hostname}:${toString exporterCfg.port}" ]; } ];
    relabel_configs = [
      {
        target_label = "instance";
        replacement = "${hostname}";
      }
      {
        target_label = "job";
        replacement = "${exporterName}";
      }
    ];
  };

  mkScrapeConfigHost = hostname: exporters: lib.mapAttrs (mkScrapeConfigExporter hostname) exporters;
  scrapeConfigsByHost = lib.mapAttrs mkScrapeConfigHost enabledExporters;

  autogenScrapeConfigs = lib.flatten (
    map builtins.attrValues (builtins.attrValues scrapeConfigsByHost)
  );
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

  services.prometheus = {
    enable = true;
    port = 9001;

    scrapeConfigs = autogenScrapeConfigs;

    exporters = {
      node = {
        enable = true;
        enabledCollectors = [ "systemd" ];
        port = 9002;
      };
    };
  };
}
