{ config, self, ... }:
{
  imports = [
    self.homeModules.dotfiles
  ];

  xdg.configFile."DankMaterialShell/plugin_settings.json".source =
    "${config.dotfiles.path}/.config/DankMaterialShell/plugin_settings.json";
}
