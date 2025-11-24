{ self, lib, ... }:
{
  imports = [
    self.nixosModules.nix-defaults
    self.nixosModules.nextcloud
    self.nixosModules.gitea

    self.inputs.srvos.nixosModules.server
  ];

  nixpkgs.hostPlatform = "x86_64-linux";

  networking.hostName = "verbena";

  networking.useDHCP = lib.mkDefault true;

  networking.defaultGateway6 = {
    address = self.infra.machines.verbena.gateway6;
    interface = "ens3";
  };
  networking.interfaces."ens3" = {
    ipv6.addresses = [
      {
        address = self.infra.machines.verbena.ipv6;
        prefixLength = 64;
      }
    ];
  };

  clan.core.settings.state-version.enable = true;

  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];

  security.acme.acceptTerms = true;
}
