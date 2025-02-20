{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    bottom
    btop
    difftastic
    doggo
    duf
    eza
    fd
    glow
    ripgrep
    skim
    tealdeer
    tree
    vivid
    zoxide
  ];

  programs.zoxide.enable = true;
  programs.starship.enable = true;
  programs.atuin.enable = true;
  programs.bat.enable = true;

  programs.zsh = {
    enable = true;
    syntaxHighlighting.enable = true;
    shellAliases = {
      ls = "eza";
      lsa = "ls -A";
      ll = "ls -lh";
      lla = "ls -lAh";
      h = "hx";
      g = "git";
      cd = "z";
      ".." = "cd ..";
      "..." = "cd ../..";
    };
  };

  xdg.configFile."git".source = "${config.dotfiles.path}/.config/git";
}
