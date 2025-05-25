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
          priority = 1;
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
          end = "-4G";
          content = {
            type = "filesystem";
            format = "ext4";
            mountpoint = "/";
          };
        };
        swap = {
          size = "100%";
          content = {
            type = "swap";
          };
        };
      };
    };
  };
}
