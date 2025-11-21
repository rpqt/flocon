{ self, lib, ... }:
let
  tf_outputs = builtins.fromJSON (builtins.readFile ../../infra/outputs.json);
in
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

  networking.defaultGateway6 = {
    address = tf_outputs.verbena_gateway6.value;
    interface = "ens3";
  };
  networking.interfaces."ens3" = {
    ipv6.addresses = [
      {
        address = tf_outputs.verbena_ipv6.value;
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

  security.acme = {
    acceptTerms = true;
    defaults.email = "admin@turifer.dev";
  };
}
