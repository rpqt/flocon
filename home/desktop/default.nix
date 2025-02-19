{ pkgs, ... }:
{
  imports = [
    ./fonts.nix
    ./pass.nix
    ./wayland.nix
  ];

  home.packages = with pkgs; [
    discord
    seahorse
  ];

  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.capitaine-cursors;
    name = "capitaine-cursors";
  };

  gtk.enable = true;
}
