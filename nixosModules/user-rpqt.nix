{
  config,
  lib,
  pkgs,
  ...
}:
{
  users.users.rpqt = {
    isNormalUser = true;

    createHome = lib.mkDefault true;
    home = lib.mkDefault "/home/rpqt";

    description = "Romain Paquet";

    shell = pkgs.fish;

    extraGroups = [
      "wheel"
    ]
    ++ (if config.networking.networkmanager ? enabled then [ "networkmanager" ] else [ ]);
  };

  programs.fish.enable = true;
}
