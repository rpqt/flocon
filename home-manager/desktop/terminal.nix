{
  config,
  pkgs,
  self,
  ...
}:
{
  imports = [
    self.homeManagerModules.dotfiles
  ];

  home.packages = [
    pkgs.alacritty
    pkgs.ghostty
  ];

  programs.alacritty.enable = true;
  xdg.configFile."alacritty/alacritty.toml".source =
    "${config.dotfiles.path}/.config/alacritty/alacritty.toml";

  xdg.configFile."ghostty/config".source = "${config.dotfiles.path}/.config/ghostty/config";
}
