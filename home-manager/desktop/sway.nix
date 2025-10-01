{
  self,
  config,
  pkgs,
  ...
}:
{
  imports = [
    self.homeManagerModules.dotfiles
    ./wayland.nix
  ];

  home.packages = with pkgs; [
    alacritty
    ghostty
    tofi
    i3status-rust
    wlsunset
    kanshi
    grim
    slurp
    playerctl
    swaybg
  ];

  xdg.configFile = {
    "sway".source = "${config.dotfiles.path}/.config/sway";
    "swaylock".source = "${config.dotfiles.path}/.config/swaylock";
    "swayidle".source = "${config.dotfiles.path}/.config/swayidle";
    "kanshi".source = "${config.dotfiles.path}/.config/kanshi";
    "i3status-rust".source = "${config.dotfiles.path}/.config/i3status-rust";
    "tofi/config".source = "${config.dotfiles.path}/.config/tofi/config";
  };

  programs.alacritty.enable = true;
  xdg.configFile."alacritty".source = "${config.dotfiles.path}/.config/alacritty";

  xdg.configFile."ghostty/config".source = "${config.dotfiles.path}/.config/ghostty/config";
}
