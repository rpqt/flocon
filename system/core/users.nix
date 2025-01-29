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

    initialHashedPassword = "$y$j9T$.y7GZIaYYgEHt1spMsOqi/$k4O3AAKBhJF0gI.G9/Ja8ssGsVTv3VPD5WC.7ErAUD1";

    extraGroups = [
      "wheel"
    ];
  };

  programs.zsh.enable = true;
}
