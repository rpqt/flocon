{
  self,
  config,
  pkgs,
  ...
}:
{
  imports = [
    self.homeModules.dotfiles
  ];

  home.packages = with pkgs; [ senpai ];

  xdg.configFile."senpai".source = "${config.dotfiles.path}/.config/senpai";
}
