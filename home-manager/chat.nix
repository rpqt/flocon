{
  self,
  config,
  pkgs,
  ...
}:
{
  imports = [
    self.homeManagerModules.dotfiles
  ];

  home.packages = with pkgs; [ senpai ];

  xdg.configFile."senpai".source = "${config.dotfiles.path}/.config/senpai";
}
