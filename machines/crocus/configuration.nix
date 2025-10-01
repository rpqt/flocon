{
  self,
  ...
}:
{
  imports = [
    ./radicle.nix
    self.nixosModules.nix-defaults
    ../../modules/remote-builder.nix
    ./nextcloud.nix
    ../../modules/unbound.nix
    ../../modules/unbound-auth.nix
    self.nixosModules.gitea
    self.inputs.srvos.nixosModules.server
    self.inputs.srvos.nixosModules.hardware-hetzner-cloud
  ];

  disabledModules = [
    self.inputs.srvos.nixosModules.mixins-cloud-init
  ];

  nixpkgs.hostPlatform = "x86_64-linux";

  networking.hostName = "crocus";

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

  clan.core.settings.state-version.enable = true;

  services.avahi.allowInterfaces = [
    "zts7mq7onf"
  ];

  boot.loader.grub = {
    efiSupport = true;
    efiInstallAsRemovable = true;
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

  services.tailscale.useRoutingFeatures = "server";
}
