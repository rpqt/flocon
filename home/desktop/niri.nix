{ config, ... }:
{
  xdg.configFile."i3bar-river".source = "${config.dotfiles.path}/.config/i3bar-river";
  xdg.configFile."niri".source = "${config.dotfiles.path}/.config/niri";
}
