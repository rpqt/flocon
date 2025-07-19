{
  disko.devices.disk.main = {
    name = "main-72b27bb5253045f38a07b6bc368ab85c";
    type = "disk";
    device = "/dev/disk/by-id/ata-WD_Green_M.2_2280_480GB_2251E6411147";
    content = {
      type = "gpt";
      partitions = {
        ESP = {
          type = "EF00";
          size = "512M";
          priority = 1;
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
