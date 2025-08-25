{ config, ... }:
{
  imports = [
    ./ignis.nix
  ];

  xdg.configFile."niri".source = "${config.dotfiles.path}/.config/niri";
}
