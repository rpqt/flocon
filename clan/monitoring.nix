{ self, ... }:
{
  clan.inventory.instances.prometheus = {
    module.input = "self";
    module.name = "@rpqt/prometheus";

    roles.scraper.machines.renoir = { };
    roles.scraper.settings = {
      extraScrapeConfigs = [
        {
          job_name = "garage";
          static_configs = [
            {
              labels.instance = "crocus";
              targets = [ "crocus.val:3903" ];
            }
            {
              labels.instance = "renoir";
              targets = [ "renoir.val:3903" ];
            }
            {
              labels.instance = "verbena";
              targets = [ "verbena.val:3903" ];
            }
          ];
          authorization = {
            type = "Bearer";
            credentials_file = "/run/credentials/prometheus.service/garage_metrics_token_path";
          };
        }
      ];
    };
    roles.scraper.extraModules = [
      ({ config, ... }: {
        systemd.services.prometheus.serviceConfig = {
          LoadCredential = [
            "garage_metrics_token_path:${config.clan.core.vars.generators.garage.files.metrics_token.path}"
          ];
        };
      })
    ];

    roles.target.tags = [ "server" ];
    roles.target.settings = {
      exporters = {
        node = {
          enabledCollectors = [
            "systemd"
          ];
        };
      };
    };
  };
}
