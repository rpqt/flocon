{ self, ... }:
{ lib, ... }:
{
  _class = "clan.service";
  manifest.name = "prometheus";
  manifest.description = "Prometheus metrics collection across the clan network.";
  manifest.readme = builtins.readFile ./README.md;

  # Only works with zerotier (until a unified network module is ready)

  roles.scraper = {
    description = "A server that scrapes metrics from exporters of machines that have the 'target' role.";
    interface = {
      options.extraScrapeConfigs = lib.mkOption {
        type = lib.types.listOf lib.types.attrs;
        description = "A list of additional scrape configurations.";
      };
    };

    perInstance =
      {
        settings,
        roles,
        ...
      }:
      {
        nixosModule =
          { config, lib, ... }:
          {
            services.prometheus.enable = true;
            services.prometheus.scrapeConfigs =
              let
                allExporters = lib.unique (
                  lib.concatLists (
                    lib.map (machine: lib.attrNames machine.settings.exporters) (lib.attrValues roles.target.machines)
                  )
                );
                hasExporter =
                  exporter: machine: lib.hasAttr exporter roles.target.machines.${machine}.settings.exporters;
                mkScrapeConfig = (
                  exporter:
                  let
                    machinesWithExporter = lib.filter (hasExporter exporter) (lib.attrNames roles.target.machines);
                  in
                  {
                    job_name = exporter;
                    static_configs = lib.map (machineName: {
                      targets =
                        let
                          targetConfig = self.nixosConfigurations.${machineName}.config;
                          targetHost = targetConfig.clan.core.vars.generators.zerotier.files.zerotier-ip.value;
                        in
                        [
                          "${targetHost}:${toString targetConfig.services.prometheus.exporters.${exporter}.port}"
                        ];
                      labels.instance = machineName;
                    }) machinesWithExporter;
                  }
                );
              in
              (lib.map mkScrapeConfig allExporters) ++ settings.extraScrapeConfigs;

            clan.core.state.prometheus.folders = [ "/var/lib/${config.services.prometheus.stateDir}" ];
          };
      };
  };

  roles.target = {
    description = "A machine on which to collect and export metrics.";
    interface =
      { lib, ... }:
      {
        options = {
          exporters = lib.mkOption {
            type = lib.types.attrs;
            default = { };
            example = {
              node = {
                enabledCollectors = [ "systemd" ];
                port = 9002;
              };
            };
            description = "Attribute set of exporters to enable";
          };
        };
      };

    perInstance =
      {
        instanceName,
        settings,
        machine,
        roles,
        ...
      }:
      {
        nixosModule =
          { config, lib, ... }:
          {
            services.prometheus.exporters = builtins.mapAttrs (
              name: exporterSettings:
              exporterSettings
              // {
                enable = true;
              }
            ) settings.exporters;

            networking.firewall.interfaces."zts7mq7onf".allowedTCPPorts = lib.map (
              exporterName: config.services.prometheus.exporters.${exporterName}.port
            ) (lib.attrNames settings.exporters);
          };
      };
  };
}
