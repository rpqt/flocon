{ self, config, ... }:
{
  imports = [
    self.homeManagerModules.dotfiles
    ./ignis.nix
  ];

  xdg.configFile."niri".source = "${config.dotfiles.path}/.config/niri";
}
