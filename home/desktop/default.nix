{ config, pkgs, ... }:
{
  imports = [
    ./pass.nix
  ];

  home.packages = [
    pkgs.nerd-fonts.jetbrains-mono

    pkgs.alacritty
    pkgs.tofi
    pkgs.i3status-rust
    pkgs.wlsunset

    pkgs.discord

    pkgs.seahorse
  ];

  fonts.fontconfig.enable = true;

  programs.alacritty.enable = true;
  xdg.configFile."alacritty".source = "${config.dotfiles.path}/.config/alacritty";

  xdg.configFile = {
    "sway".source = "${config.dotfiles.path}/.config/sway";
    "i3status-rust".source = "${config.dotfiles.path}/.config/i3status-rust";
    "tofi/config".source = "${config.dotfiles.path}/.config/tofi/config";
  };

  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.capitaine-cursors;
    name = "capitaine-cursors-4";
  };
}
