{ self, ... }:
{
  clan.inventory.instances.prometheus = {
    module.input = "self";
    module.name = "@rpqt/prometheus";

    roles.scraper.machines.genepi = { };
    roles.scraper.settings = {
      extraScrapeConfigs = [
        {
          job_name = "garage";
          static_configs = [
            {
              labels.instance = "crocus";
              targets = [ "crocus.home.rpqt.fr:3903" ];
            }
            {
              labels.instance = "genepi";
              targets = [ "genepi.home.rpqt.fr:3903" ];
            }
            {
              labels.instance = "verbena";
              targets = [ "verbena.home.rpqt.fr:3903" ];
            }
          ];
          authorization = {
            type = "Bearer";
            credentials_file =
              self.nixosConfigurations.verbena.config.clan.core.vars.generators.garage.files.metrics_token.path;
          };
        }
      ];
    };

    roles.target.tags.server = { };
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
