{ pkgs, ... }:
let
  pass-alias = pkgs.writeShellScriptBin "pass" ''
    exec ${pkgs.passage}/bin/passage "$@"
  '';
in
{
  home.packages = [
    # pkgs.pass
    pass-alias
    pkgs.gnupg
    pkgs.pinentry-gnome3
  ];

  # programs.gpg.enable = true;
  services.gpg-agent = {
    enable = false;
    pinentry.package = pkgs.pinentry-gnome3;
  };
}
