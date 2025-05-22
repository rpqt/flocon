{
  keys,
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

    openssh.authorizedKeys.keys = [ keys.rpqt.haze ];

    extraGroups = [
      "wheel"
    ];
  };

  programs.zsh.enable = true;
}
