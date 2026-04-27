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

  clan.inventory.instances.data-mesher = {
    roles.bootstrap.tags = [ "server" ];
    roles.default.tags = [ "all" ];
  };

  clan.inventory.instances.dm-dns = {
    module.name = "dm-dns";
    roles.push.machines = {
      haze = { };
      renoir = { };
    };
    roles.default.tags = [ "all" ];
    roles.push.extraModules = [
      (
        { config, pkgs, ... }:
        {
          environment.systemPackages = [
            (pkgs.writeShellApplication {
              name = "dm-send-dns";
              runtimeInputs = [
                config.services.data-mesher.package
                pkgs.sops
              ];
              text = ''
                data-mesher file update \
                  "${config.clan.core.vars.generators.dm-dns.files."zone.conf".path}" \
                  --url http://localhost:7331 \
                  --network-id "${config.clan.core.vars.generators.data-mesher-network.files."network.pub".path}" \
                  --key "$(sops decrypt vars/shared/dm-dns-signing-key/signing.key/secret)" \
                  --name "dns/cnames"
              '';
            })
          ];
        }
      )
    ];
  };
}
