{ pkgs, ... }:
{
  home.packages = with pkgs; [
    devenv
    direnv
    radicle-node
    typescript-language-server
    nil # Nix language server
    nixfmt-rfc-style
  ];

  programs.direnv.enable = true;
}
