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

  home.packages = [ pkgs.helix ];

  programs.helix = {
    enable = true;
    defaultEditor = true;
  };

  home.sessionVariables.EDITOR = "hx";

  xdg.configFile."helix/config.toml".source = "${config.dotfiles.path}/.config/helix/config.toml";
  xdg.configFile."helix/languages.toml".source =
    "${config.dotfiles.path}/.config/helix/languages.toml";
}
