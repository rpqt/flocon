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
    gh
    hut
    jujutsu
    nix-output-monitor
    python3
    radicle-desktop
    radicle-node
    radicle-tui
    typescript-language-server
    nil # Nix language server
    nixfmt-rfc-style
    nixpkgs-review
  ];

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  xdg.configFile."hut/config".source = "${config.dotfiles.path}/.config/hut/config";
  home.file.".ssh/config".source = "${config.dotfiles.path}/.ssh/config";
}
