{ self, lib, ... }:
{
  imports = [
    ./machines.nix
    ./monitoring.nix
    ./network.nix
  ];

  clan.meta.name = "blossom";
  clan.meta.domain = "val";

  clan.secrets.age.plugins = [
    "age-plugin-yubikey"
  ];

  clan.inventory.instances."rpqt-admin" = {
    module.input = "clan-core";
    module.name = "admin";
    roles.default.tags.server = { };
    roles.default.machines.haze = { };
    roles.default.settings.allowedKeys = {
      rpqt_haze = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGa8R8obgptefcp27Cdp9bc2fiyc9x0oTfMsTPFp2ktE rpqt@haze";
      nixbld_haze = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIyNC2sn5m7m52r4kVZqg0T7abqdz5xh/blU3cYtHKAE nixbld@haze";
    };
  };

  clan.inventory.instances."sshd" = {
    module.input = "clan-core";
    module.name = "sshd";
    roles.server.tags.all = { };
    roles.server.extraModules = [
      self.nixosModules.hardened-ssh-server
    ];
    roles.server.settings = {
      certificate.searchDomains = [
        "home.rpqt.fr"
      ];
    };

    roles.client.tags.all = { };
    roles.client.settings = {
      certificate.searchDomains = [
        "home.rpqt.fr"
      ];
    };
  };

  clan.inventory.instances.user-rpqt = {
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
  };

  clan.inventory.instances."garage-config" = {
    module.input = "clan-core";
    module.name = "importer";
    roles.default.tags.garage = { };
    roles.default.extraModules = [ ../modules/garage.nix ];
  };

  clan.inventory.instances."trusted-nix-caches" = {
    module.input = "clan-core";
    module.name = "trusted-nix-caches";
    roles.default.tags.all = { };
  };

  clan.inventory.instances."borgbackup-storagebox" = {
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
          } -oStrictHostKeyChecking=accept-new";
        };
      }
    );
    roles.client.extraModules = [
      ../modules/storagebox.nix
    ];
    roles.server.machines = { };
  };

  clan.inventory.instances.syncthing = {
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

  clan.inventory.instances.buildbot = {
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

}
