{ self, ... }:
{
  clan.inventory.instances.yggdrasil = {
    roles.default.tags.all = { };
  };

  clan.inventory.instances.zerotier = {
    roles.controller.machines.crocus = { };
    roles.moon.machines.crocus.settings = {
      stableEndpoints = [
        self.infra.machines.crocus.ipv4
        self.infra.machines.crocus.ipv6
      ];
    };
    roles.peer.tags."all" = { };
  };

  clan.inventory.instances.internet = {
    roles.default.machines.verbena.settings.host = self.infra.machines.verbena.ipv4;
    roles.default.machines.crocus.settings.host = self.infra.machines.crocus.ipv4;
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
      renoir = { };
    };
  };

  clan.inventory.instances.pki = {
    module.name = "pki";
    roles.default.tags.all = { };
  };

  clan.inventory.instances.dns = {
    module.input = "self";
    module.name = "@schallerclan/dns";

    roles.server.tags = [ "dns" ];
    roles.default.tags = [ "all" ];

    roles.default.machines."renoir".settings = {
      records = {
        AAAA = [
          "205:8a34:1a76:f16c:964c:36e:7240:630f" # yggdrasil
        ];
      };
    };

    roles.default.machines."verbena".settings = {
      records = {
        AAAA = [
          "200:b038:ab12:ac69:8675:7e47:41f4:12f4" # yggdrasil
        ];
      };
      services = [ "vaultwarden" ];
    };

    roles.default.machines."crocus".settings = {
      records = {
        AAAA = [
          "200:bcfc:9787:29b9:46e0:e75d:a912:dfdc" # yggdrasil
        ];
      };
    };

    roles.default.machines."genepi".settings = {
      records = {
        AAAA = [
          "200:b839:2d6f:3dad:adab:e104:26e2:f12b" # yggdrasil
        ];
      };
      services = [
        "actual"
        "assistant"
        "glance"
        "grafana"
        "images"
        "lounge"
        "pinchflat"
        "rss"
      ];
    };
  };
}
