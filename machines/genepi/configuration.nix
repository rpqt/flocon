{
  self,
  lib,
  ...
}:
{
  imports = [
    ./network.nix
    ./nginx.nix

    self.nixosModules.nix-defaults
    self.nixosModules.rpi4
  ];

  image.modules.sd-card = {
    disabledModules = [
      ./hardware-configuration.nix
    ];
    users.users.rpqt = {
      hashedPasswordFile = lib.mkForce null;
      password = "foo";
    };
  };

  networking.hostName = "genepi";

  time.timeZone = "Europe/Paris";

  clan.core.settings.state-version.enable = true;
}
