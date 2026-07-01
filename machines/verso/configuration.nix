{ self, ... }:
{
  imports = [
    self.nixosModules.atuin-config
    self.nixosModules.desktop
    self.nixosModules.niri
    self.nixosModules.nix-defaults
    self.nixosModules.steam
    ../haze/syncthing.nix

    self.inputs.home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.rpqt = ../haze/home.nix;
      home-manager.extraSpecialArgs = {
        inherit self;
      };
    }
  ];

  time.timeZone = "Europe/Paris";

}
