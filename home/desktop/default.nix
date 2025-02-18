{ pkgs, ... }:
{
  imports = [
    ./fonts.nix
    ./pass.nix
  ];

  home.packages = with pkgs; [
    discord
    seahorse

    wl-clipboard
  ];

  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.capitaine-cursors;
    name = "capitaine-cursors";
  };

  gtk.enable = true;
}
