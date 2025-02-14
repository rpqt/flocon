{ config, pkgs, ... }:

{
  home.packages = [ pkgs.helix ];

  programs.helix = {
    enable = true;
    defaultEditor = true;
  };

  xdg.configFile."helix".source = "${config.dotfiles.path}/.config/helix";
}
