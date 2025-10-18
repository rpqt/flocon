{ self, lib, ... }:
{
  imports = [
    self.nixosModules.nix-defaults
    ../../modules/unbound.nix
    ../../modules/unbound-auth.nix
    self.nixosModules.nextcloud
    self.nixosModules.gitea

    self.inputs.srvos.nixosModules.server
  ];

  nixpkgs.hostPlatform = "x86_64-linux";

  networking.hostName = "verbena";

  networking.useDHCP = lib.mkDefault true;

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

  security.acme = {
    acceptTerms = true;
    defaults.email = "admin@turifer.dev";
  };
}
