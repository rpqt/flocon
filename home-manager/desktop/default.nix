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
  ];

  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 24;
  };

  gtk.enable = true;
  gtk.iconTheme = {
    name = "WhiteSur";
    package = pkgs.whitesur-icon-theme.override {
      alternativeIcons = true;
      boldPanelIcons = true;
    };
  };

  qt.enable = true;
  qt.platformTheme.name = "gtk";
}
