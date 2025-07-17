{
  clan = {
    meta.name = "blossom";

    inventory.machines = {
      crocus = {
        deploy.targetHost = "root@crocus";
        tags = [
          "garage"
        ];
      };
      genepi = {
        deploy.targetHost = "root@genepi";
        tags = [
          "garage"
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
              "167.235.28.141"
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
    };
  };
}
