{
  self,
  pkgs,
  ...
}:
{
  imports = [
    self.nixosModules.atuin-config
    self.nixosModules.desktop
    self.nixosModules.niri
    self.nixosModules.nix-defaults
    self.nixosModules.steam
    ../haze/syncthing.nix

    {
      services.nginx = {
        enable = true;
        # recommendedProxySettings = true;
        # recommendedTlsSettings = true;
      };

      networking.firewall.interfaces."ygg".allowedTCPPorts = [
        80
        443
      ];
    }

    self.inputs.home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.rpqt = ./home.nix;
      home-manager.extraSpecialArgs = {
        inherit self;
      };
    }

    {
      security.acme.acceptTerms = true;
    }
  ];

  time.timeZone = "Europe/Paris";
}
