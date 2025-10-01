{ lib, pkgs, ... }:
{
  users.users.rpqt = {
    isNormalUser = true;

    createHome = lib.mkDefault true;
    home = lib.mkDefault "/home/rpqt";

    description = "Romain Paquet";

    shell = pkgs.zsh;

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGa8R8obgptefcp27Cdp9bc2fiyc9x0oTfMsTPFp2ktE rpqt@haze"
    ];

    extraGroups = [ "wheel" ];
  };

  programs.zsh.enable = true;
}
