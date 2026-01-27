{
  config,
  pkgs,
  self,
  ...
}:
{
  imports = [
    self.homeModules.dotfiles
  ];

  home.packages = [
    pkgs.alacritty
    pkgs.ghostty
  ];

  programs.alacritty.enable = true;
  xdg.configFile."alacritty".source = "${config.dotfiles.path}/.config/alacritty";

  xdg.configFile."ghostty/config".source = "${config.dotfiles.path}/.config/ghostty/config";
}
