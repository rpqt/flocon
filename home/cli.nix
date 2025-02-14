{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    difftastic
    doggo
    duf
    eza
    fd
    ripgrep
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
      ll = "ls -lh";
      lsa = "ls -A";
      h = "hx";
      g = "git";
      cd = "z";
      ".." = "cd ..";
      "..." = "cd ../..";
    };
  };

  xdg.configFile."git".source = "${config.dotfiles.path}/.config/git";
}
