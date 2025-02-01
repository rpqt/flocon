{ pkgs, inputs, ... }:
{
  home.username = "rpqt";
  home.homeDirectory = "/home/rpqt";

  home.packages = [
    pkgs.helix
    pkgs.ripgrep
    pkgs.eza
  ];

  programs.zsh.enable = true;
  programs.starship.enable = true;
  programs.atuin.enable = true;

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
