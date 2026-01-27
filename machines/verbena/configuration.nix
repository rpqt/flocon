{ self, lib, ... }:
{
  imports = [
    self.nixosModules.nix-defaults
    self.nixosModules.nextcloud
    self.nixosModules.gitea
    self.nixosModules.forgejo
    self.nixosModules.vaultwarden

    self.inputs.srvos.nixosModules.server

    {
      # Add Pixel-7a as external device for clan wireguard network
      networking.wireguard.interfaces.wireguard = {
        ips = [ "100.42.42.1/32" ];
        peers = [
          {
            publicKey = "BVgDQM18SfNofQsWs7m6fblaTB04Gk74VxR/zK8AKQ4=";
            allowedIPs =
              let
                suffix = "cafe:cafe";
              in
              [ "fd28:387a:90:c400:${suffix}::/96" ];
            persistentKeepalive = 25;
          }
        ];
      };
    }
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
