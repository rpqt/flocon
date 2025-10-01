{
  self,
  config,
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    self.homeManagerModules.dotfiles
    inputs.ignis.homeManagerModules.default
  ];

  home.packages = [
    pkgs.brightnessctl
    pkgs.swaybg
    pkgs.swaylock
    pkgs.tofi
    pkgs.wl-gammarelay-rs
    inputs.matugen.packages.${pkgs.system}.default
  ];

  programs.ignis = {
    enable = true;

    addToPythonEnv = false;

    sass.enable = true;
    sass.useDartSass = true;

    services.bluetooth.enable = true;
    services.audio.enable = true;
    services.network.enable = true;
  };

  xdg.configFile."ignis".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/rep/heath";
}
