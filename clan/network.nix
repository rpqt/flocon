{ self, ... }:
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
    };
  };

  clan.inventory.instances.certificates = {
    module.name = "certificates";
    module.input = "clan-core";

    roles.ca.machines.verbena = {
      settings.acmeEmail = "admin@rpqt.fr";
      settings.tlds = [ "val" ];
    };
    roles.default.tags.all = { };
    roles.default.settings.acmeEmail = "admin@rpqt.fr";
  };

  # Temporarily patched version of clan-core/coredns for AAAA records support
  clan.inventory.instances.coredns = {
    module.name = "@rpqt/coredns";
    module.input = "self";

    roles.default.tags.all = { };
    roles.server.machines.verbena = {
      settings.ip = "fd28:387a:90:c400::1";
    };
    roles.server.machines.crocus = {
      settings.ip = "fd28:387a:90:c400:6db2:dfc3:c376:9956";
    };
    roles.server.settings = {
      tld = "val";
    };

    roles.default.machines.verbena.settings = {
      ip = "fd28:387a:90:c400::1";
      services = [
        "ca"
      ];
    };

    roles.default.machines.genepi.settings = {
      ip = "fd28:387a:90:c400:ab23:3d38:a148:f539"; # FIXME: IPv4 expected (A record)
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
