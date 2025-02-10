{ pkgs, inputs, ... }:
{
  home.username = "rpqt";
  home.homeDirectory = "/home/rpqt";

  home.packages = [
    inputs.agenix.packages.x86_64-linux.default

    pkgs.helix

    pkgs.devenv
    pkgs.direnv
    pkgs.radicle-node

    pkgs.deploy-rs

    pkgs.nil # Nix language server
    pkgs.nixfmt-rfc-style
  ];

  programs.zsh.enable = true;
  programs.starship.enable = true;
  programs.atuin.enable = true;
  programs.bat.enable = true;
  programs.git.enable = true;

  programs.alacritty.enable = true;

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.11";

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;
}
