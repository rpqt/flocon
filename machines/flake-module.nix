{ self, lib, ... }:
{
  clan = {
    meta.name = "blossom";

    inventory.machines = {
      crocus = {
        deploy.targetHost = "root@crocus";
        tags = [
          "garage"
          "server"
        ];
      };
      genepi = {
        deploy.targetHost = "root@genepi";
        tags = [
          "garage"
          "server"
          "syncthing"
        ];
      };
      haze = {
        tags = [
          "syncthing"
        ];
      };
    };

    inventory.instances = {
      "rpqt-admin" = {
        module.input = "clan-core";
        module.name = "admin";
        roles.default.machines = {
          "crocus" = { };
          "genepi" = { };
          "haze" = { };
        };
        roles.default.settings.allowedKeys = {
          rpqt_haze = (import ../parts).keys.rpqt.haze;
        };
      };

      "rpqt-zerotier" = {
        module.input = "clan-core";
        module.name = "zerotier";
        roles.controller.machines.crocus = { };
        roles.moon.machines.crocus = {
          settings = {
            stableEndpoints = [
              "116.203.18.122"
              "2a01:4f8:1c1e:e415::/64"
            ];
          };
        };
        roles.peer.tags."all" = { };
      };

      "avahi" = {
        module.input = "clan-core";
        module.name = "garage";
        roles.default.tags.all = { };
        roles.default.extraModules = [
          {
            services.avahi = {
              enable = true;
              nssmdns4 = true;
              nssmdns6 = true;
              publish = {
                enable = true;
                domain = true;
                userServices = true;
                addresses = true;
              };
            };
          }
        ];
      };

      "sshd" = {
        module.input = "clan-core";
        module.name = "sshd";
        roles.server.tags.all = { };
      };

      "rpqt-password-haze" = {
        module.input = "clan-core";
        module.name = "users";
        roles.default.machines.haze = {
          settings = {
            user = "rpqt";
          };
        };
      };

      "garage" = {
        module.input = "clan-core";
        module.name = "garage";
        roles.default.tags.garage = { };
      };

      "garage-config" = {
        module.input = "clan-core";
        module.name = "importer";
        roles.default.tags.garage = { };
        roles.default.extraModules = [ ../modules/garage.nix ];
      };

      "trusted-nix-caches" = {
        module.input = "clan-core";
        module.name = "trusted-nix-caches";
        roles.default.tags.all = { };
      };

      "borgbackup-storagebox" = {
        module.input = "clan-core";
        module.name = "borgbackup";

        roles.client.machines = lib.genAttrs [ "crocus" "genepi" ] (
          machine:
          let
            config = self.nixosConfigurations.${machine}.config;
            user = "u422292";
            host = "${user}.your-storagebox.de";
          in
          {
            settings.destinations."storagebox-${config.networking.hostName}" = {
              repo = "${user}@${host}:./borgbackup/${config.networking.hostName}";
              rsh = "ssh -oPort=23 -i ${config.clan.core.vars.generators.borgbackup.files."borgbackup.ssh".path}";
            };
          }
        );
        roles.client.extraModules = [
          ../modules/storagebox.nix
        ];
        roles.server.machines = { };
      };

      prometheus = {
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
              ];
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

      syncthing = {
        roles.peer.tags.syncthing = { };
        roles.peer.settings.folders = {
          Documents = {
            path = "~/Documents";
          };
          Music = {
            path = "~/Music";
          };
          Pictures = {
            path = "~/Pictures";
          };
          Videos = {
            path = "~/Videos";
          };
        };
        roles.peer.settings.extraDevices = {
          pixel-7a = {
            id = "IZE7B4Z-LKTJY6Q-77NN4JG-ADYRC77-TYPZTXE-Q35BWV2-AEO7Q3R-ZE63IAU";
            name = "Pixel 7a";
            addresses = [ "dynamic" ];
          };
        };
      };
    };
  };
}
