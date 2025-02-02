{
  lib,
  self,
  ...
}:
let
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
