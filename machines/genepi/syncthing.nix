{
  config,
  lib,
  pkgs,
  ...
}:
let
  user = "rpqt";
  home = config.users.users.${user}.home;
  tld = "val";
  domain = "genepi.${tld}";
in
{

  services.nginx.virtualHosts.${domain} = {
    forceSSL = true;
    enableACME = true;
    locations."/syncthing" = {
      proxyPass = "http://${config.services.syncthing.guiAddress}";
    };
  };

  security.acme.certs.${domain}.server = "https://ca.${tld}/acme/acme/directory";

  services.syncthing = {
    enable = true;
    user = user;
    group = lib.mkForce "users";
    dataDir = home;
    configDir = lib.mkForce "${home}/.config/syncthing";
    guiAddress = "0.0.0.0:8384";
    guiPasswordFile = config.clan.core.vars.generators.syncthing-gui.files.password.path;
  };

  networking.firewall.interfaces.wireguard = {
    allowedTCPPorts = [ 8384 ];
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
