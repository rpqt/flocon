{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    alacritty
    tofi
    i3status-rust
    mako
    wlsunset
    kanshi
    grim
    slurp
    playerctl
  ];

  xdg.configFile = {
    "sway".source = "${config.dotfiles.path}/.config/sway";
    "swaylock".source = "${config.dotfiles.path}/.config/swaylock";
    "swayidle".source = "${config.dotfiles.path}/.config/swayidle";
    "i3status-rust".source = "${config.dotfiles.path}/.config/i3status-rust";
    "tofi/config".source = "${config.dotfiles.path}/.config/tofi/config";
  };

  programs.alacritty.enable = true;
  xdg.configFile."alacritty".source = "${config.dotfiles.path}/.config/alacritty";
}
