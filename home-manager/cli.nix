{
  self,
  config,
  osConfig,
  pkgs,
  ...
}:
{
  imports = [
    self.homeManagerModules.dotfiles
  ];

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
    tealdeer
    vivid
    yazi
    zoxide
  ];

  programs.zoxide.enable = true;
  programs.starship.enable = true;
  programs.bat.enable = true;

  programs.atuin.enable = true;
  xdg.dataFile."atuin/key".source =
    config.lib.file.mkOutOfStoreSymlink osConfig.clan.core.vars.generators.atuin.files.key.path;

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
