{
  inputs,
  modulesPath,
  config,
  ...
}:
{
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
    # ./radicle.nix
    ../../system
    inputs.clan-core.clanModules.state-version
    ../../modules/remote-builder.nix
    ../../modules/borgbackup.nix
    ./topology.nix
  ];

  nixpkgs.hostPlatform = "x86_64-linux";

  networking.hostName = "crocus";
  clan.core.networking.targetHost = "root@crocus.local";

  networking.useDHCP = false;
  systemd.network.enable = true;
  systemd.network.networks."10-wan" = {
    matchConfig.Name = "enp1s0";
    networkConfig.DHCP = "ipv4";
    address = [
      "2a01:4f8:1c1e:e415::1/64"
    ];
    routes = [
      { Gateway = "fe80::1"; }
    ];
  };

  services.avahi.enable = true;

  disko.devices.disk.main.device = "/dev/disk/by-id/scsi-0QEMU_QEMU_HARDDISK_48353082";

  boot.loader.grub = {
    efiSupport = true;
    efiInstallAsRemovable = true;
  };

  services.prometheus = {
    enable = true;
    port = 9001;
    exporters = {
      node = {
        enable = true;
        enabledCollectors = [ "systemd" ];
        port = 9002;
      };
    };

    scrapeConfigs = [
      {
        job_name = "crocus";
        static_configs = [
          {
            targets = [ "127.0.0.1:${toString config.services.prometheus.exporters.node.port}" ];
          }
        ];
      }
    ];
  };

  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];

  security.acme = {
    acceptTerms = true;
    defaults.email = "admin@rpqt.fr";
  };
}
