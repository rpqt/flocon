{
  self,
  config,
  osConfig,
  pkgs,
  ...
}:
let
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
in
{
  imports = [
    self.homeModules.dotfiles
  ];

  home.packages = with pkgs; [
    age
    age-plugin-yubikey
    bottom
    btop
    comma
    difftastic
    doggo
    duf
    eza
    fd
    glow
    jjui
    lazygit
    nh
    passage
    rage
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

  programs.zsh = {
    enable = true;
    syntaxHighlighting.enable = true;
    inherit shellAliases;
  };

  programs.fish = {
    enable = true;
    inherit shellAliases;
  };

  programs.zellij.enable = true;

  # programs.khal = {
  #   enable = true;
  # };

  # accounts.calendar.basePath = ".calendar";

  # programs.pimsync.enable = true;

  # accounts.calendar.accounts.personal = {
  #   pimsync.enable = true;
  #   khal.enable = true;
  #   thunderbird.enable = true;
  #   remote = {
  #     url = "https://cloud.rpqt.fr/remote.php/dav/calendars/rpqt/personal/";

  #     type = "caldav";
  #     userName = "rpqt@rpqt.fr";
  #     passwordCommand = [
  #       "sh"
  #       "-c"
  #       "passage web/cloud.rpqt.fr | head -n 1"
  #     ];
  #   };
  # };

  xdg.configFile."git".source = "${config.dotfiles.path}/.config/git";
  xdg.configFile."jj/config.toml".source = "${config.dotfiles.path}/.config/jj/config.toml";
  xdg.configFile."task/taskrc".source = "${config.dotfiles.path}/.config/task/taskrc";

  home.sessionPath = [ "${config.dotfiles.path}/bin" ];
}
