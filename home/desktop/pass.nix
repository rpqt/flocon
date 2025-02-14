{ pkgs, ... }:
{
  home.packages = [
    pkgs.pass
    pkgs.gnupg
    pkgs.pinentry-gnome3
  ];

  programs.gpg.enable = true;
  services.gpg-agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-gnome3;
  };
}
