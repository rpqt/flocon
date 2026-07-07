{ self, ... }:
{ lib, ... }:
{
  _class = "clan.service";
  manifest.name = "prometheus";
  manifest.description = "Prometheus metrics collection across the clan network.";
  manifest.readme = builtins.readFile ./README.md;
  manifest.exports.out = [
    "endpoints"
  ];

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
        meta,
        mkExports,
        ...
      }:
      let
        host = "grafana.${meta.domain}";
      in
      {
        exports = mkExports {
          endpoints.hosts = [ host ];
        };

        nixosModule =
          { config, pkgs, ... }:
          {
            services.prometheus.enable = true;
            services.prometheus.checkConfig = "syntax-only";
            services.prometheus.scrapeConfigs =
              let
                allExporters = lib.unique (
                  lib.concatLists (
                    map (machine: lib.attrNames machine.settings.exporters) (lib.attrValues roles.target.machines)
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
                    static_configs = map (machineName: {
                      targets =
                        let
                          targetConfig = self.nixosConfigurations.${machineName}.config;
                          isIPv6 = addr: builtins.match ".*:.*:.*" addr != null;
                          escapeIPv6 = addr: if isIPv6 addr then "[${addr}]" else addr;
                          targetHost = escapeIPv6 (lib.head targetConfig.clan.core.networking.internalListenAddresses);
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

            # Grafana

            services.grafana = {
              enable = true;
              settings = {
                server = {
                  http_port = 3000;
                  domain = host;
                };
                security = {
                  secret_key = config.clan.core.vars.generators.grafana-secret.files.key.path;
                  csrf_trusted_origins = host;
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
                        url = "http://127.0.0.1:${toString config.services.prometheus.port}"; # TODO: decouple
                        isDefault = true;
                      }
                    ];
                  };
                };
              };
            };

            clan.core.vars.generators.grafana-secret = {
              files.key = { };
              runtimeInputs = [
                pkgs.openssl
              ];
              script = "openssl rand -hex 32 > $out/key";
            };

            services.nginx.virtualHosts.${host} = {
              forceSSL = true;
              locations."/" = {
                proxyPass = "http://127.0.0.1:${toString config.services.grafana.settings.server.http_port}";
                proxyWebsockets = true;
              };
            };
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
          let
            isIPv6 = addr: builtins.match ".*:.*:.*" addr != null;
            escapeIPv6 = addr: if isIPv6 addr then "[${addr}]" else addr;
          in
          {
            services.prometheus.exporters = builtins.mapAttrs (
              name: exporterSettings:
              exporterSettings
              // {
                enable = true;
                listenAddress = escapeIPv6 (lib.head config.clan.core.networking.internalListenAddresses); # TODO: what if there are multiple addresses?
                openFirewall = true;
              }
            ) settings.exporters;

            networking.firewall.interfaces."zts7mq7onf".allowedTCPPorts = lib.map (
              exporterName: config.services.prometheus.exporters.${exporterName}.port
            ) (lib.attrNames settings.exporters);
          };
      };
  };
}
