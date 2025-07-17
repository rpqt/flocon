{
  config,
  ...
}:
let
  user = "rpqt";
  home = config.users.users.${user}.home;
in
{
  services.syncthing = {
    enable = true;
    user = user;
    group = "users";
    dataDir = home;
    configDir = "${home}/.config/syncthing";
    key = config.clan.core.vars.generators.syncthing.files."key".path;
    cert = config.clan.core.vars.generators.syncthing.files."cert".path;
    openDefaultPorts = true;
    overrideDevices = true;
    overrideFolders = true;
    settings = {
      devices = {
        "genepi" = {
          id = "TNP3M2Z-2AJ3CJE-4LLYHME-3KWCLN4-XQWBIDJ-PTDRANE-RRBYQWQ-KXJFTQU";
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

  clan.core.vars.generators.syncthing = {
    prompts.key = {
      description = "syncthing private key";
      type = "hidden";
      persist = true;
    };
    files.key.owner = config.services.syncthing.user;

    prompts.cert = {
      description = "syncthing cert";
      type = "hidden";
      persist = true;
    };
    files.cert.owner = config.services.syncthing.user;
  };
}
