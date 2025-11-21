{
  clan.inventory.instances.zerotier = {
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

  clan.inventory.instances.internet = {
    roles.default.machines.verbena = {
      settings.host = "git.turifer.dev";
    };
  };

  clan.inventory.instances.wireguard = {
    module.name = "wireguard";
    module.input = "clan-core";
    roles.controller = {
      machines.verbena.settings = {
        endpoint = "wg1.turifer.dev";
      };
    };
    roles.peer.machines = {
      haze = { };
      crocus = { };
      genepi = { };
    };
  };
}
