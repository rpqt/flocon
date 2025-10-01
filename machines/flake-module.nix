{ self, lib, ... }:
{
  clan = {
    meta.name = "blossom";
    inventory.machines = {
      crocus = {
        tags = [
          "garage"
          "server"
        ];
      };
      genepi = {
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
      verbena = {
        tags = [
          "garage"
          "server"
        ];
      };
    };

    inventory.instances = {
      "rpqt-admin" = {
        module.input = "clan-core";
        module.name = "admin";
        roles.default.tags.server = { };
        roles.default.machines.haze = { };
        roles.default.settings.allowedKeys = {
          rpqt_haze = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGa8R8obgptefcp27Cdp9bc2fiyc9x0oTfMsTPFp2ktE rpqt@haze";
        };
      };

      zerotier = {
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

      internet = {
        roles.default.machines.crocus = {
          settings.host = "git.turifer.dev";
        };
      };

      "sshd" = {
        module.input = "clan-core";
        module.name = "sshd";
        roles.server.tags.all = { };
        roles.server.extraModules = [
          self.nixosModules.hardened-ssh-server
        ];
      };

      user-rpqt = {
        module.input = "clan-core";
        module.name = "users";
        roles.default.machines.haze = {
          settings = {
            user = "rpqt";
          };
        };
        roles.default.extraModules = [
          self.nixosModules.user-rpqt
        ];
      };

      common-config = {
        module = {
          input = "clan-core";
          name = "importer";
        };
        roles.default.tags.all = { };
        roles.default.extraModules = [ self.nixosModules.common ];
      };

      server-config = {
        module = {
          input = "clan-core";
          name = "importer";
        };
        roles.default.tags.server = { };
        roles.default.extraModules = [
          {
            nix.gc.automatic = true;
            nix.gc.dates = "Mon 3:15";
            nix.gc.randomizedDelaySec = "30min";
            nix.gc.options = "--delete-older-than 30d";
          }
        ];
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

        roles.client.machines = lib.genAttrs [ "crocus" "genepi" "verbena" ] (
          machine:
          let
            config = self.nixosConfigurations.${machine}.config;
            user = "u422292";
            host = "${user}.your-storagebox.de";
          in
          {
            settings.destinations."storagebox-${config.networking.hostName}" = {
              repo = "${user}@${host}:./borgbackup/${config.networking.hostName}";
              rsh = "ssh -oPort=23 -i ${
                config.clan.core.vars.generators.borgbackup.files."borgbackup.ssh".path
              } -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null";
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

      buildbot = {
        module.input = "self";
        module.name = "@rpqt/buildbot";

        roles.master.machines.verbena = {
          settings = {
            domain = "buildbot.turifer.dev";
            admins = [ "rpqt" ];
            topic = "buildbot-nix";
            gitea.instanceUrl = "https://git.turifer.dev";
          };
        };

        roles.master.extraModules = [
          {
            services.nginx.virtualHosts."buildbot.turifer.dev" = {
              enableACME = true;
              forceSSL = true;
            };

            security.acme.certs."buildbot.turifer.dev" = {
              email = "admin@turifer.dev";
            };
          }
        ];

        roles.worker.machines.verbena = { };
      };
    };
  };
}
