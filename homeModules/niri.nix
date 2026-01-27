{ self, config, ... }:
{
  imports = [
    self.homeModules.dotfiles
  ];

  xdg.configFile."niri".source = "${config.dotfiles.path}/.config/niri";
}
