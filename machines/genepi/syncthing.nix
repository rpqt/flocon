{
  config,
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
    group = "users";
    dataDir = home;
    configDir = "${home}/.config/syncthing";
    openDefaultPorts = true;
    overrideDevices = true;
    overrideFolders = true;
    settings = {
      devices = {
        "haze" = {
          id = "INMEQOC-5WT5JMJ-EYCBQVQ-LK2CIFQ-A5IRXPR-724CPE6-Z5A4UTH-5QGO4QD";
        };
        "pixel-7a" = {
          id = "IZE7B4Z-LKTJY6Q-77NN4JG-ADYRC77-TYPZTXE-Q35BWV2-AEO7Q3R-ZE63IAU";
        };
      };
      folders = {
        "Documents" = {
          path = "${home}/Documents";
          devices = [
            "haze"
          ];
        };
        "Music" = {
          path = "${home}/Media/Music";
          devices = [
            "haze"
            "pixel-7a"
          ];
        };
        "Pictures" = {
          path = "${home}/Media/Pictures";
          devices = [
            "haze"
          ];
        };
        "Videos" = {
          path = "${home}/Media/Videos";
          devices = [
            "haze"
          ];
        };
      };
    };
  };
}
