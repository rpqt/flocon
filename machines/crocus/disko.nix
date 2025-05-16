{
  clan-core,
  config,
  ...
}:
let
  suffix = config.clan.core.vars.generators.disk-id.files.diskId.value;
in
{
  imports = [ clan-core.clanModules.disk-id ];

  disko.devices.disk.main = {
    name = "main-" + suffix;
    type = "disk";
    content = {
      type = "gpt";
      partitions = {
        boot = {
          type = "EF02";
          size = "1M";
        };
        ESP = {
          type = "EF00";
          size = "512M";
          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = "/boot";
          };
        };
        root = {
          size = "100%";
          content = {
            type = "filesystem";
            format = "ext4";
            mountpoint = "/";
          };
        };
      };
    };
  };
}
