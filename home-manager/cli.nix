{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    bottom
    btop
    comma
    difftastic
    doggo
    duf
    eza
    fd
    glow
    lazygit
    nh
    ripgrep
    skim
    taskwarrior3
    tealdeer
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
      tree = "eza --tree";
      ".." = "cd ..";
      "..." = "cd ../..";
    };
  };

  xdg.configFile."git".source = "${config.dotfiles.path}/.config/git";
  xdg.configFile."jj/config.toml".source = "${config.dotfiles.path}/.config/jj/config.toml";
  xdg.configFile."task/taskrc".source = "${config.dotfiles.path}/.config/task/taskrc";

  home.sessionPath = [ "${config.dotfiles.path}/bin" ];
}
