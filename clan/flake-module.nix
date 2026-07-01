{ self, lib, ... }:
{
  imports = [
    ./backups.nix
    ./glance/flake-module.nix
    ./machines.nix
    ./monitoring.nix
    ./network.nix
    ./users.nix
  ];

  clan.meta.name = "blossom";
  clan.meta.domain = "val";

  clan.secrets.age.plugins = [
    "age-plugin-yubikey"
  ];

  clan.inventory.instances."sshd" = {
    module.input = "clan-core";
    module.name = "sshd";

    roles.server.tags.all = { };
    roles.server.extraModules = [
      self.nixosModules.hardened-ssh-server
    ];
    roles.server.settings = {
      authorizedKeys = {
        rpqt_haze = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGa8R8obgptefcp27Cdp9bc2fiyc9x0oTfMsTPFp2ktE rpqt@haze";
        nixbld_haze = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIyNC2sn5m7m52r4kVZqg0T7abqdz5xh/blU3cYtHKAE nixbld@haze";
        rpqt_verso = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGwlZDKQ8hTeD/ngPSp/7DFjtoySyTaB3bDFQ+jPaPdy rpqt@verso";
      };
    };
  };

  clan.inventory.instances.common-config = {
    module = {
      input = "clan-core";
      name = "importer";
    };
    roles.default.tags.all = { };
    roles.default.extraModules = [ self.nixosModules.common ];
  };

  clan.inventory.instances.server-config = {
    module = {
      input = "clan-core";
      name = "importer";
    };
    roles.default.tags.server = { };
    roles.default.extraModules = [
      {
        nix.gc.automatic = lib.mkDefault true;
        nix.gc.dates = lib.mkDefault "Mon 3:15";
        nix.gc.randomizedDelaySec = lib.mkDefault "30min";
        nix.gc.options = lib.mkDefault "--delete-older-than 30d";
      }
    ];
  };

  clan.inventory.instances."garage" = {
    module.input = "clan-core";
    module.name = "garage";
    roles.default.tags.garage = { };
    roles.default.extraModules = [ self.nixosModules.garage ];
  };

  clan.inventory.instances."trusted-nix-caches" = {
    module.input = "clan-core";
    module.name = "trusted-nix-caches";
    roles.default.tags.all = { };
  };

  clan.inventory.instances.vaultwarden = {
    module.input = "self";
    module.name = "@rpqt/vaultwarden";
    roles.default.machines.verbena = { };
  };

  clan.inventory.instances.home-assistant = {
    module.input = "self";
    module.name = "@rpqt/home-assistant";
    roles.default.machines.genepi = { };
  };

  clan.inventory.instances.auth0 = {
    module.input = "clan-community";
    module.name = "authelia";

    roles.default.machines.verbena.settings = {
      publicHost = "auth.rpqt.fr";
      domain = "rpqt.fr";
    };
  };

  clan.inventory.instances.nixbot = {
    module.input = "self";
    module.name = "@rpqt/nixbot";
    roles.default.machines.verbena.settings = {
      oidcDomain = "auth.rpqt.fr";
      domain = "nixbot.rpqt.fr";
      admins = [ "oidc:auth.rpqt.fr:rpqt" ];
    };
  };

  # clan.inventory.instances.firefox-syncserver = {
  # module.input = "self";
  # module.name = "@rpqt/firefox-syncserver";
  # roles.server.machines.renoir = { };
  # };

  clan.inventory.instances.webapps = {
    module.input = "clan-community";
    module.name = "webapps";
    roles.default.tags = [ "desktop" ];
  };
}
