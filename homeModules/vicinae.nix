{
  config,
  lib,
  ...
}:
{
  programs.vicinae = {
    enable = true;
    systemd.enable = true;
    systemd.autoStart = true;
  };

  xdg.configFile."vicinae/settings.json".source =
    lib.mkForce "${config.dotfiles.path}/.config/vicinae/settings.json";

  xdg.configFile."matugen/config.toml".source = "${config.dotfiles.path}/.config/matugen/config.toml";
  xdg.configFile."matugen/templates/vicinae.toml".source =
    "${config.dotfiles.path}/.config/matugen/templates/vicinae.toml";
}
