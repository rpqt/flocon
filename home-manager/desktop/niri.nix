{ self, config, ... }:
{
  imports = [
    self.homeManagerModules.dotfiles
    ./wayland.nix
  ];

  xdg.configFile."niri".source = "${config.dotfiles.path}/.config/niri";
}
