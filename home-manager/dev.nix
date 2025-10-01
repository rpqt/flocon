{
  self,
  config,
  pkgs,
  ...
}:
{
  imports = [
    ./cli.nix
    ./helix.nix
    self.homeManagerModules.dotfiles
  ];

  home.packages = with pkgs; [
    direnv
    hut
    jujutsu
    nix-output-monitor
    python3
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
