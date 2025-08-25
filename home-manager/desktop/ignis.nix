{ config, inputs, ... }:
{
  imports = [
    inputs.ignis.homeManagerModules.default
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
