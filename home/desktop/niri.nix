{ config, ... }:
{
  xdg.configFile."niri".source = "${config.dotfiles.path}/.config/niri";
}
