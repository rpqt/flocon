{ pkgs, ... }:
{
  imports = [
    ./fonts.nix
    ./pass.nix
    ./terminal.nix
    ./wayland.nix
  ];

  home.packages = with pkgs; [
    discord
    seahorse
    wofi-emoji
  ];

  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 24;
  };

  gtk.enable = true;
}
