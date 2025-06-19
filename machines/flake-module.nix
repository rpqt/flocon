{

  clan = {
    meta.name = "blossom";

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
    };

    inventory.services = {
      sshd.default = {
        roles.server.tags = [ "all" ];
      };
      user-password.rpqt = {
        roles.default.machines = [
          "crocus"
          "genepi"
          "haze"
        ];
        config.user = "rpqt";
      };
    };
  };
}
