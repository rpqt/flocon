{
  self,
  pkgs,
  ...
}:
{
  imports = [
    self.nixosModules.atuin-config
    self.nixosModules.desktop
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
      programs.niri.enable = true;

      environment.systemPackages = with pkgs; [
        pavucontrol
        playerctl
        xwayland-satellite
      ];

      services.gnome.gnome-keyring.enable = true;

      environment.sessionVariables.NIXOS_OZONE_WL = "1";

      programs.dms-shell.enable = true;

      security.acme.acceptTerms = true;
    }
  ];
}
