{
  config,
  lib,
  ...
}:
let
  user = "rpqt";
  home = config.users.users.${user}.home;
  domain = "home.rpqt.fr";
  subdomain = "genepi.${domain}";
in
{

  services.nginx.virtualHosts.${subdomain} = {
    forceSSL = true;
    useACMEHost = "${domain}";
    locations."/syncthing".proxyPass = "http://${config.services.syncthing.guiAddress}";
  };

  services.syncthing = {
    enable = true;
    user = user;
    group = lib.mkForce "users";
    dataDir = home;
    configDir = lib.mkForce "${home}/.config/syncthing";
    guiPasswordFile = config.clan.core.vars.generators.syncthing-gui.files.password.path;
  };

  clan.core.vars.generators.syncthing-gui = {
    files.password = {
      secret = true;
      owner = user;
    };
    runtimeInputs = [ pkgs.xkcdpass ];
    script = ''
      xkcdpass -n 7 > $out/password
    '';
  };
}
