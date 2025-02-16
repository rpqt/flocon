{
  config,
  ...
}:
let
  user = "rpqt";
  home = config.users.users.${user}.home;
in
{
  age.secrets.syncthing-key.file = ./secrets/syncthing-key.pem.age;
  age.secrets.syncthing-cert.file = ./secrets/syncthing-cert.pem.age;

  services.syncthing = {
    enable = true;
    user = user;
    group = "users";
    dataDir = home;
    configDir = "${home}/.config/syncthing";
    key = config.age.secrets.syncthing-key.path;
    cert = config.age.secrets.syncthing-cert.path;
    openDefaultPorts = true;
    overrideDevices = true;
    overrideFolders = true;
    settings = {
      devices = {
        "genepi" = {
          id = "EA7DC7O-IHB47EQ-AWT2QBJ-AWPDF5S-W4EM66A-KQPCTHI-UX53WKM-QTSAHQ4";
        };
        "pixel-7a" = {
          id = "IZE7B4Z-LKTJY6Q-77NN4JG-ADYRC77-TYPZTXE-Q35BWV2-AEO7Q3R-ZE63IAU";
        };
      };
      folders = {
        "Documents" = {
          path = "${home}/Documents";
          devices = [
            "genepi"
            "pixel-7a"
          ];
        };
        "Music" = {
          path = "${home}/Music";
          devices = [
            "genepi"
            "pixel-7a"
          ];
        };
        "Pictures" = {
          path = "${home}/Pictures";
          devices = [
            "genepi"
          ];
        };
        "Videos" = {
          path = "${home}/Videos";
          devices = [
            "genepi"
          ];
        };
      };
    };
  };
}
