{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    devenv
    direnv
    hut
    jujutsu
    nix-output-monitor
    radicle-node
    typescript-language-server
    nil # Nix language server
    nixfmt-rfc-style
  ];

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  xdg.configFile."hut/config".source = "${config.dotfiles.path}/.config/hut/config";
}
