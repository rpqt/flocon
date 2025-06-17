{
  config,
  lib,
  pkgs,
  ...
}:
{
  users.mutableUsers = lib.mkDefault false;

  users.users.rpqt = {
    isNormalUser = true;

    createHome = true;
    home = "/home/rpqt";

    description = "Romain Paquet";

    shell = pkgs.zsh;

    openssh.authorizedKeys.keys = [ (import ../../parts/keys.nix).rpqt.haze ];

    extraGroups = [
      "wheel"
    ];
  };

  programs.zsh.enable = true;
}
